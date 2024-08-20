//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashPresenter
import FCMDomain
import RecordsDomain
import MyPageDomain
import AppCoordinator

import ReactorKit
import RxSwift

public final class SplashReactorImp: SplashReactor {
  public typealias Action = SplashReactorAction
  public typealias Mutation = SplashReactorMutation
  public typealias State = SplashReactorState
  
  public let initialState: State
  public let coordinator: any AppCoordinator
  
  private let checkTokenUseCase: CheckTokenUsecase
  private let checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase
  private let fcmSaveUseCase: FCMSaveUseCase
  private let checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  private let removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase
  private let profileInfoUseCase: ProfileInfoUseCase
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    profileInfoUseCase: ProfileInfoUseCase
  ) {
    self.coordinator = coordinator
    self.checkTokenUseCase = checkTokenUseCase
    self.checkIsFirstLoadedUseCase = checkIsFirstLoadedUseCase
    self.fcmSaveUseCase = fcmSaveUseCase
    self.checkRecordCalendarUseCase = checkRecordCalendarUseCase
    self.removeGlobalCalendarRecordsUseCase = removeGlobalCalendarRecordsUseCase
    self.profileInfoUseCase = profileInfoUseCase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkToken:
      return checkIsFirstLoadedUseCase.execute()
        .flatMap { isAlreadyLoaded in
          isAlreadyLoaded ? self.handleTokenCheckFlow() : .just(.startAuth)
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .startAuth:
      coordinator.destination.accept(.startAuth)
    case .startMain:
      coordinator.destination.accept(.startHome)
    }
    return newState
  }
}

// MARK: - Private Methods

extension SplashReactorImp {
  
  private func checkToken() -> Observable<Bool> {
    guard let accessToken = checkTokenUseCase.execute() else {
      return .just(false) // 토큰이 없으면 인증 필요
    }
    return .just(true) // 토큰이 있으면 메인으로
  }
  
  private func handleTokenCheckFlow() -> Observable<Mutation> {
    return checkToken()
      .flatMap { isAuthenticated in
        isAuthenticated ? self.performPostAuthenticationTasks() : .just(.startAuth)
      }
      .catchAndReturn(.startAuth)
  }
  
  private func performPostAuthenticationTasks() -> Observable<Mutation> {
    // FCM 토큰 저장, 기록 캘린더 확인을 순차적으로 처리
    return saveFCMToken()
      .flatMap { _ in self.checkRecordCalendar() }
      .flatMap { _ in self.fetchProfileInfo() }
      .map { _ in .startMain }
      .catchAndReturn(.startAuth)
  }
  
  private func saveFCMToken() -> Observable<Void> {
    return fcmSaveUseCase.execute()
      .asObservable()
      .do(onNext: { _ in
        print("FCM 토큰 저장 완료")
      })
  }
  
  private func checkRecordCalendar() -> Observable<Void> {
    /// 우선 저장되어 있는 GlobalRecords 지우고, 새로운 calendar fetch
    return removeGlobalCalendarRecordsUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in owner.fetchCalendarRecords(cursor: "2024-01-01", limit: 30) }
  }
  
  private func fetchCalendarRecords(cursor: String, limit: Int) -> Observable<Void> {
    return checkRecordCalendarUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { calendarModel -> Observable<Void> in
        if let nextCursor = calendarModel.nextCursor.nextCursor {
          return self.fetchCalendarRecords(cursor: nextCursor, limit: limit)
        } else {
          return .just(Void())
        }
      }
      .catch { error in return .just(Void()) }
  }
  
  private func fetchProfileInfo() -> Observable<Void> {
    return profileInfoUseCase.execute()
      .asObservable()
      .map { _ in Void() }
  }
}
