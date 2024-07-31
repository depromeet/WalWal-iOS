//
//  AuthReactorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import Foundation
import AuthDomain
import AuthPresenter
import AuthCoordinator
import LocalStorage

import ReactorKit
import RxSwift

public final class AuthReactorImp: AuthReactor {
  public typealias Action = AuthReactorAction
  public typealias Mutation = AuthReactorMutation
  public typealias State = AuthReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  private let appleLoginUseCase: AppleLoginUseCase
  
  public init(
    coordinator: any AuthCoordinator,
    appleLoginUseCase: AppleLoginUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.appleLoginUseCase = appleLoginUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLoginTapped(authCode):
      return appleLoginUseCase.excute(authCode: authCode)
        .asObservable()
        .flatMap { result -> Observable<Mutation> in
          UserDefaults.setValue(value: result.refreshToken, forUserDefaultKey: .refreshToken)
          
          return .never()
        }
        .catch { error -> Observable<Mutation> in
          return .just(.loginErrorMsg(msg: "로그인에 실패하였습니다"))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = State()
    switch mutation {
    case let .loginErrorMsg(msg):
      newState.message = msg
    }
    return newState
  }
}
