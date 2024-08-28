//
//  TermsReactorImp.swift
//  MyPagePresenterImp
//
//  Created by Jiyeon on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageCoordinator
import MyPagePresenter

import ReactorKit

public final class TermsReactorImp: TermsReactor {
  public typealias Action = TermsReactorAction
  public typealias Mutation = TermsReactorMutation
  public typealias State = TermsReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(coordinator: any MyPageCoordinator) {
    self.coordinator = coordinator
    initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .close:
      return .just(.close)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case .close:
      coordinator.dismissViewController(completion: nil)
    }
    return initialState
  }
}
