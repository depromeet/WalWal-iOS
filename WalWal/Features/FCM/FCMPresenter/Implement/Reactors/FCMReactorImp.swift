//
//  FCMReactorImp.swift
//
//  FCM
//
//  Created by Jiyeon
//

import FCMDomain
import FCMPresenter
import FCMCoordinator

import ReactorKit
import RxSwift

public final class FCMReactorImp: SplashReactor {
  public typealias Action = FCMReactorAction
  public typealias Mutation = FCMReactorMutation
  public typealias State = FCMReactorState
  
  public let initialState: State
  public let coordinator: any __Coordinator
  
  public init(
    coordinator: any __Coordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
