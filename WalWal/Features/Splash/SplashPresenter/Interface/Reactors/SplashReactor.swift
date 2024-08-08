//
//  SplashReactor.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import AppCoordinator

import ReactorKit
import RxSwift

public enum SplashReactorAction {
  case checkToken(flow: AppCoordinatorFlow)
}

public enum SplashReactorMutation {
  case startAuth
  case startMain
}

public struct SplashReactorState {
  public init() {}
}

public protocol SplashReactor:
  Reactor where Action == SplashReactorAction,
                Mutation == SplashReactorMutation,
                  State == SplashReactorState {
  
  var coordinator: any AppCoordinator { get }
  
  init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase
  )
}
