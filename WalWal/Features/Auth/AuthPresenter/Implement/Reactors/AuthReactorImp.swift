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

import FCMDomain

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
  
  public init(
    coordinator: any AuthCoordinator,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.socialLoginUseCase = socialLoginUseCase
    self.fcmSaveUseCase = fcmSaveUseCase
    self.userTokensSaveUseCase = userTokensSaveUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLoginTapped(authCode):
      return .concat([
        .just(.showIndicator(show: true)),
        socialLoginRequest(provider: .apple, token: authCode)
      ])
    case let .kakaoLoginTapped(accessToken):
      return .concat([
        .just(.showIndicator(show: true)),
        socialLoginRequest(provider: .kakao, token: accessToken)
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
          return owner.fcmTokenSave()
        }
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.loginErrorMsg(msg: "로그인에 실패하였습니다"))
        ])
      }
  }
  
  private func fcmTokenSave() -> Observable<Mutation> {
    return fcmSaveUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        owner.coordinator.startMission()
        return .just(.showIndicator(show: false))
      }
      .catch { _ -> Observable<Mutation> in
        print("FCM 토큰 저장 오류")
        self.coordinator.startMission()
        return .just(.showIndicator(show: false))
      }
  }
}
