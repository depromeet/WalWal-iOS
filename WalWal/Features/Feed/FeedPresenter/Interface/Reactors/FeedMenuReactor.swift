//
//  FeedMenuReactor.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedCoordinator
import ReactorKit

public enum FeedMenuReactorAction {
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case tapDimView
  case menuItemTap(item: MenuItem)
}

public enum FeedMenuReactorMutation {
  case setSheetPosition(CGFloat)
  case dismissSheet
  case moveReport
}

public struct FeedMenuReactorState {
  public var sheetPosition: CGFloat = 0
  public var recordId: Int
  public init(recordId: Int) {
    self.recordId = recordId
  }
}

public protocol FeedMenuReactor: Reactor where Action == FeedMenuReactorAction, Mutation == FeedMenuReactorMutation, State == FeedMenuReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    recordId: Int
  )
}

public enum MenuItem {
  case report
}
