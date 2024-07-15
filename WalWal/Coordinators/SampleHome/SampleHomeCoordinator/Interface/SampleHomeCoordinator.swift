//
//  SampleHomeCoordinatorInterface.swift
//
//  SampleHome
//
//  Created by 조용인
//

import UIKit
import Utility

public enum SampleHomeCoordinatorAction: ParentAction {
  case logout
}

public enum SampleHomeCoordinatorFlow: CoordinatorFlow {
  case showProfile
  case showSettings
}

public protocol SampleHomeCoordinator: CoordinatorType { }
