//
//  AuthCoordinatorInterface.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import BaseCoordinator

public enum AuthCoordinatorAction: ParentAction {
  case startOnboarding
  case startMission
}

public enum AuthCoordinatorFlow: CoordinatorFlow {
  
}

public protocol AuthCoordinator: BaseCoordinator { 
  func startOnboarding()
  func startMission()
}
