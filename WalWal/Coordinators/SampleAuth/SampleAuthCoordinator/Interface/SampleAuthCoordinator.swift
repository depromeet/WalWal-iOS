//
//  SampleAuthCoordinatorInterface.swift
//
//  SampleAuth
//
//  Created by 조용인
//

import UIKit
import Utility

public enum SampleAuthCoordinatorAction: ParentAction {
  case authenticationCompleted
  case authenticationFailed(Error)
}

public enum SampleAuthCoordinatorFlow: CoordinatorFlow {
  case showSignIn
  case showSignUp
}

public protocol SampleAuthCoordinator: CoordinatorType { }
