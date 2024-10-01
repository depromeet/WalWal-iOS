//
//  FeedMenuReactorImp.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FeedPresenter
import FeedCoordinator

import ReactorKit

public final class FeedMenuReactorImp: FeedMenuReactor {
  
  public typealias Action = FeedMenuReactorAction
  public typealias Mutation = FeedMenuReactorMutation
  public typealias State = FeedMenuReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  public init(
    coordinator: any FeedCoordinator,
    recordId: Int
  ) {
    self.initialState = State(recordId: recordId)
    self.coordinator = coordinator
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didPan(translation, _):
      return Observable.just(.setSheetPosition(translation.y))
    case let .didEndPan(velocity):
      if velocity.y > 1000 {
        return Observable.just(.dismissSheet)
      } else {
        return Observable.just(.setSheetPosition(0))
      }
    case .tapDimView:
      return Observable.just(.dismissSheet)
    case let .menuItemTap(item):
      switch item {
      case .report:
        return .just(.moveReport)
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSheetPosition(position):
      newState.sheetPosition = position
    case .dismissSheet:
      coordinator.dismissViewController(animated: false) { }
    case .moveReport:
      coordinator.startReport()
    }
    return newState
  }
}
