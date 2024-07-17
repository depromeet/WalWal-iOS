//
//  AuthReactorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import AuthDomain
import AuthPresenter
import AuthCoordinator

import ReactorKit
import RxSwift



public final class AuthReactorImp: AuthReactor {
  public typealias Action = AuthReactorAction
  public typealias Mutation = AuthReactorMutation
  public typealias State = AuthReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  
  public init(
    coordinator: any AuthCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLogin(authCode):
      print(authCode)
      return .never()
    }  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
