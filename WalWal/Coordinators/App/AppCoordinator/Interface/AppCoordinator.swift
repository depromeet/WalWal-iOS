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
  case startTab
}

public protocol AppCoordinator: BaseCoordinator { }
