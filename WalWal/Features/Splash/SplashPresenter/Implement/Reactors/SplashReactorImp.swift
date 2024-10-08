//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit
import SplashDomain
import SplashPresenter
import FCMDomain
import RecordsDomain
import MembersDomain
import AppCoordinator
import Utility

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
        .do(onDispose:  {
          AppUpdateManager.shared.checkForUpdate()
        })
    case .moveUpdate:
      return moveAppStore()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .startAuth:
      coordinator.destination.accept(.startAuth)
    case .startMain:
      coordinator.destination.accept(.startHome)
    case let .openAppStore(url):
      newState.url = url
    }
    return newState
  }
}

// MARK: - Private Methods

extension SplashReactorImp {
  
  private func moveAppStore() -> Observable<Mutation> {
    var country = "kr"
    if #available(iOS 16.0, *){ country = NSLocale.current.language.region!.identifier }
    guard let url = URL(string: "https://apps.apple.com/\(country)/app/%EC%99%88%EC%99%88/id6553981069") else {
      return .never()
    }
    return .just(.openAppStore(url: url))
  }
  
  private func checkToken() -> Observable<Bool> {
    guard let _ = checkTokenUseCase.execute() else {
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
    return memberInfoUseCase.execute(memberId: nil)
      .asObservable()
      .map { _ in Void() }
  }
}
