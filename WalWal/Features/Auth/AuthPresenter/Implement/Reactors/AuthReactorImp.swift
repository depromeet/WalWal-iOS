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

public enum AuthReactorActionImp: AuthReactorAction {
  case appleLogin(authCode: String)
}

public enum AuthReactorMutationImp: AuthReactorMutation {
  /// 구체적인 뮤테이션 정의
}

public struct AuthReactorStateImp: AuthReactorState {
  /// 구체적인 상태 정의
  public init() {
    
  }
}

public final class AuthReactorImp: AuthReactor {
  public typealias Action = AuthReactorActionImp
  public typealias Mutation = AuthReactorMutationImp
  public typealias State = AuthReactorStateImp
  
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
