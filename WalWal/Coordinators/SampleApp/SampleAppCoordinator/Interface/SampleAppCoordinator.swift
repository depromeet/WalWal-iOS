//
//  SampleAppCoordinatorInterface.swift
//
//  SampleApp
//
//  Created by 조용인
//

import UIKit
import Utility

public enum SampleAppCoordinatorAction: ParentAction {
  case never
}

public enum SampleAppCoordinatorFlow: CoordinatorFlow {
  case startAuth
  case startHome
}

public protocol SampleAppCoordinator: CoordinatorType {

}
