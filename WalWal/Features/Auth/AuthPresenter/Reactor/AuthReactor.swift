//
//  AuthReactor.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ReactorKit
import RxSwift

public class AuthReactor: Reactor {
  public enum Action {
    case appleLogin(authCode: String)
  }
  
  public enum Mutation {
    
  }
  
  public struct State {
  }
  
  public let initialState: State
  
  public init() {
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLogin(authCode):
      print(authCode)
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    }
    return newState
  }
}

