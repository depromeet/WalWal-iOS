//
//  AppCoordinatorInterface.swift
//
//  App
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator

public enum AppCoordinatorAction: ParentAction {
  case never
}

public enum AppCoordinatorFlow: CoordinatorFlow {
  case startAuth
  case startHome
  case startOnboarding
}

public protocol AppCoordinator: BaseCoordinator where Flow == AppCoordinatorFlow {
  func pushTabMove(to: PushNotiMoveAction)
  
}

public enum PushNotiMoveAction {
  case mission
  case feed
}
