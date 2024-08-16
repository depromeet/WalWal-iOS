//
//  OnboardingCoordinatorInterface.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import BaseCoordinator

public enum OnboardingCoordinatorAction: ParentAction {
  case startMission
}

public enum OnboardingCoordinatorFlow: CoordinatorFlow {
  case showSelect
  case showProfile(petType: String)
}

public protocol OnboardingCoordinator: BaseCoordinator
where Flow == OnboardingCoordinatorFlow,
      Action == OnboardingCoordinatorAction
{
  func startMission()
}
