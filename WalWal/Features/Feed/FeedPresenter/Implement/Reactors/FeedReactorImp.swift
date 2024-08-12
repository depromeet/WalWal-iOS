//
//  FeedReactorImp.swift
//
//  Feed
//
//  Created by 이지희
//

import FeedDomain
import FeedPresenter
import FeedCoordinator

import ReactorKit
import RxSwift

public final class FeedReactorImp: FeedReactor {
  public typealias Action = FeedReactorAction
  public typealias Mutation = FeedReactorMutation
  public typealias State = FeedReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  public init(
    coordinator: any FeedCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
