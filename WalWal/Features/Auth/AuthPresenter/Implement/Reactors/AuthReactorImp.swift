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
  private let authUseCase: AuthUseCase
  
  public init(
    coordinator: any AuthCoordinator,
    authUseCase: AuthUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.authUseCase = authUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLoginTapped(authCode):
      print(authCode)
      return .never()
      
      // TODO: - 추후 api 요청 작업 시 사용 예정
//      return authUseCase.appleLogin(authCode: authCode)
//        .asObservable()
//        .map { token in
//          return Mutation.token(token: token.token)
//        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = State()
    switch mutation {
    case let .token(token):
      print(token)
//      newState.token = token
    }
    return newState
  }
}
