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
    
  }
  
  public enum Mutation {
    
  }
  
  public struct State {
    
  }
  
  public let initialState: State
  
  init() {
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    }
    return newState
  }
}

