//
//  FCMCellReactor.swift
//  FCMPresenter
//
//  Created by Jiyeon on 9/6/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMDomain

import ReactorKit

public enum FCMCellAction {
  case changeIsReadValue(value: Bool)
}

public enum FCMCellMutation {
  case changeIsReadValue(value: Bool)
}

public final class FCMCellReactor: Reactor {
  public typealias Action = FCMCellAction
  public typealias Mutation = FCMCellMutation
  public typealias State = FCMItemModel
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .changeIsReadValue(isRead):
      return .just(.changeIsReadValue(value: isRead))
    }
  }
  public func reduce(state: FCMItemModel, mutation: Mutation) -> FCMItemModel {
    var newState = state
    switch mutation {
    case .changeIsReadValue:
      newState.isRead = true
    }
    return newState
  }
  
  public var initialState: FCMItemModel
  public init(state: FCMItemModel) {
    self.initialState = state
  }
}
