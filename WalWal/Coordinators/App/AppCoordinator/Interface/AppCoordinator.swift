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
  case startHomeByDeepLink(move: PushNotiMoveAction)
}

public protocol AppCoordinator: BaseCoordinator where Flow == AppCoordinatorFlow {
  
}

public enum PushNotiMoveAction {
  case mission
  case feed
}
