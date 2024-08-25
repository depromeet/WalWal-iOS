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
import MembersDomain
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
  private let memberInfoUseCase: MemberInfoUseCase
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) {
    self.coordinator = coordinator
    self.checkTokenUseCase = checkTokenUseCase
    self.checkIsFirstLoadedUseCase = checkIsFirstLoadedUseCase
    self.fcmSaveUseCase = fcmSaveUseCase
    self.memberInfoUseCase = memberInfoUseCase
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
    // FCM 토큰 저장, 기록 캘린더 확인, 프로필 정보 조회를 순차적으로 처리
    return saveFCMToken()
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
  
  private func fetchProfileInfo() -> Observable<Void> {
    return memberInfoUseCase.execute()
      .asObservable()
      .map { _ in Void() }
  }
}
