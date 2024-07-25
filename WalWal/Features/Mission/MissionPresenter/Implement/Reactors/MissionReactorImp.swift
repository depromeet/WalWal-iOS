//
//  MissionReactorImp.swift
//
//  Mission
//
//  Created by 이지희
//

import MissionPresenter
import MissionCoordinator

import ReactorKit
import RxSwift

public final class MissionReactorImp: MissionReactor {
  public typealias Action = MissionReactorAction
  public typealias Mutation = MissionReactorMutation
  public typealias State = MissionReactorState
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  
  public init(
    coordinator: any MissionCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
