//
//  FeedCoordinatorInterface.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator

public enum FeedCoordinatorAction: ParentAction {
  case startProfile(memberId: Int, nickName: String)
}

public enum FeedCoordinatorFlow: CoordinatorFlow {
  case showFeedMenu(recordId: Int)
}

public protocol FeedCoordinator: BaseCoordinator
where Flow == FeedCoordinatorFlow,
      Action == FeedCoordinatorAction
{
  func startProfile(memberId: Int, nickName: String)
  func doubleTap(index: Int)
}
