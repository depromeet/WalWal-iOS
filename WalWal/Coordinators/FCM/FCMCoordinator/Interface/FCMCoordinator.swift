//
//  FCMCoordinatorInterface.swift
//
//  FCM
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator

public enum FCMCoordinatorAction: ParentAction {
  case startMission
}

public enum FCMCoordinatorFlow: CoordinatorFlow {
  
}

public protocol FCMCoordinator: BaseCoordinator {
  func startMission()
}
