//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashPresenter
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
  
  public init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase
  ) {
    self.coordinator = coordinator
    self.checkTokenUseCase = checkTokenUseCase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkToken:
      return checkToken()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = State()
    switch mutation {
    case .startAuth:
      coordinator.destination.accept(.startAuth)
    case .startMain:
      coordinator.destination.accept(.startHome)
    }
    return newState
  }
}

extension SplashReactorImp {
  private func checkToken() -> Observable<Mutation> {
    guard let accessToken = checkTokenUseCase.execute() else {
      return .just(.startAuth)
    }
    return .just(.startMain)
  }
}
