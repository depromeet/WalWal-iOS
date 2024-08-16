//
//  RecordsReactorImp.swift
//
//  Records
//
//  Created by 조용인
//

import RecordsDomain
import RecordsPresenter
import RecordsCoordinator

import ReactorKit
import RxSwift

public final class RecordsReactorImp: SplashReactor {
  public typealias Action = RecordsReactorAction
  public typealias Mutation = RecordsReactorMutation
  public typealias State = RecordsReactorState
  
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
