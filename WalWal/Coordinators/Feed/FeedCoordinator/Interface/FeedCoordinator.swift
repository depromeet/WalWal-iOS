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
  
}

public enum FeedCoordinatorFlow: CoordinatorFlow {
  
}

public protocol FeedCoordinator: BaseCoordinator where Flow == FeedCoordinatorFlow {

}
