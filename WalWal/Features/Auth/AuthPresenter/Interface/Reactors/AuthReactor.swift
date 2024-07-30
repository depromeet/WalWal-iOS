//
//  AuthReactor.swift
//
//  Auth
//
//  Created by Jiyeon
//

import AuthDomain
import AuthCoordinator

import ReactorKit
import RxSwift

public enum AuthReactorAction {
  case appleLoginTapped(authCode: String)
}

public enum AuthReactorMutation {
  case loginErrorMsg(msg: String)
}

public struct AuthReactorState {
  /// 구체적인 상태 정의
  public init() { }
  @Pulse public var message: String = ""
}

public protocol AuthReactor:
  Reactor where Action == AuthReactorAction,
                  Mutation == AuthReactorMutation,
                  State == AuthReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(
    coordinator: any AuthCoordinator,
    appleLoginUseCase: AppleLoginUseCase
  )
}
