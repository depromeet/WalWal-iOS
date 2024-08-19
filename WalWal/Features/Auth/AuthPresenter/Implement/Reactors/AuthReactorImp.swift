//
//  AuthReactorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import Foundation
import AuthDomain
import AuthPresenter
import AuthCoordinator
import GlobalState

import FCMDomain
import RecordsDomain

import ReactorKit
import RxSwift

public final class AuthReactorImp: AuthReactor {
  public typealias Action = AuthReactorAction
  public typealias Mutation = AuthReactorMutation
  public typealias State = AuthReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  private let socialLoginUseCase: SocialLoginUseCase
  private let fcmSaveUseCase: FCMSaveUseCase
  private let userTokensSaveUseCase: UserTokensSaveUseCase
  private let kakaoLoginUseCase: KakaoLoginUseCase
  private let checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  private let removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase
  
  public init(
    coordinator: any AuthCoordinator,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase,
    kakaoLoginUseCase: KakaoLoginUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.socialLoginUseCase = socialLoginUseCase
    self.fcmSaveUseCase = fcmSaveUseCase
    self.userTokensSaveUseCase = userTokensSaveUseCase
    self.kakaoLoginUseCase = kakaoLoginUseCase
    self.checkRecordCalendarUseCase = checkRecordCalendarUseCase
    self.removeGlobalCalendarRecordsUseCase = removeGlobalCalendarRecordsUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLoginTapped(authCode):
      return .concat([
        .just(.showIndicator(show: true)),
        socialLoginRequest(provider: .apple, token: authCode)
      ])
    case .kakaoLoginTapped:
      return .concat([
        .just(.showIndicator(show: true)),
        kakaoLogin()
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = State()
    switch mutation {
    case let .loginErrorMsg(msg):
      newState.message = msg
    case let .showIndicator(show):
      newState.showIndicator = show
    }
    return newState
  }
}

extension AuthReactorImp {
  
  private func kakaoLogin() -> Observable<Mutation> {
    return kakaoLoginUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, token -> Observable<Mutation> in
        owner.socialLoginRequest(provider: .kakao, token: token)
      }
      .catch { _ in
        print("카카오 로그인 취소")
        return .just(.showIndicator(show: false))
      }
  }
  
  private func socialLoginRequest(provider: ProviderType, token: String) -> Observable<Mutation> {
    return socialLoginUseCase.execute(provider: provider, token: token)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        owner.userTokensSaveUseCase.execute(tokens: result)
        if result.isTemporaryToken {
          owner.coordinator.startOnboarding()
          return .just(.showIndicator(show: false))
        } else {
          return owner.loginCompleteTask()
        }
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.loginErrorMsg(msg: "로그인에 실패하였습니다"))
        ])
      }
  }
  
  private func loginCompleteTask() -> Observable<Mutation> {
    return saveFCMToken()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Void> in
        owner.checkRecordCalendar()
      }
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        owner.coordinator.startMission()
        return .just(.showIndicator(show: false))
      }
      .catch { [weak self] error -> Observable<Mutation> in
        print(error.localizedDescription)
        self?.coordinator.startMission()
        return .just(.showIndicator(show: false))
      }
  }
  
  private func saveFCMToken() -> Observable<Void> {
    return fcmSaveUseCase.execute()
      .asObservable()
  }
  
  private func checkRecordCalendar() -> Observable<Void> {
    return removeGlobalCalendarRecordsUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in owner.fetchCalendarRecords(cursor: "2024-01-01", limit: 10) }
  }
  
  private func fetchCalendarRecords(cursor: String, limit: Int) -> Observable<Void> {
    return checkRecordCalendarUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, calendarModel -> Observable<Void> in
        if let nextCursor = calendarModel.nextCursor.nextCursor {
          return owner.fetchCalendarRecords(cursor: nextCursor, limit: limit)
        } else {
          return .just(Void())
        }
      }
      .catch { error in return .just(Void()) }
  }
}
