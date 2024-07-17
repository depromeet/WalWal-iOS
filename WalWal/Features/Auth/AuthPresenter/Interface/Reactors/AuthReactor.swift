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
  case appleLogin(authCode: String)
}

public enum AuthReactorMutation {
  case token(token: String)
}

public struct AuthReactorState {
  /// 구체적인 상태 정의
  public init() { }
}
public protocol AuthReactor: 
  Reactor where Action == AuthReactorAction,
                  Mutation == AuthReactorMutation,
                  State == AuthReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(
    coordinator: any AuthCoordinator,
    authUseCase: AuthUseCase
  )
}
