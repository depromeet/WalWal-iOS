//
//  SplashReactor.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashCoordinator

import ReactorKit
import RxSwift

public enum SplashReactorAction {

}

public enum SplashReactorMutation {

}

public enum SplashReactorState {
  public init() {
  
  }
}

public protocol SplashReactor: Reactor where Action: SplashReactorAction, Mutation: SplashReactorMutation, State: SplashReactorState {
  
  var coordinator: any SplashCoordinator { get }
  
  init(
    coordinator: any SplashCoordinator
  )
}
