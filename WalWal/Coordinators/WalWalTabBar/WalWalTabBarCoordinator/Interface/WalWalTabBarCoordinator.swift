//
//  WalWalTabBarCoordinatorInterface.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import ResourceKit
import BaseCoordinator

public enum WalWalTabBarCoordinatorAction: ParentAction {
  case startAuth
}

public enum WalWalTabBarCoordinatorFlow: Int, CoordinatorFlow, CaseIterable {
  case startMission
  case startFeed
  case startNotification
  case startMyPage
}

public protocol WalWalTabBarCoordinator: BaseCoordinator {
  func specificTab(flow: WalWalTabBarCoordinatorFlow)
  func startAuth()
}
