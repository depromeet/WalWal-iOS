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
  
}

public enum OnboardingCoordinatorFlow: CoordinatorFlow {
  case showSelect
  case showProfile
}

public protocol OnboardingCoordinator: BaseCoordinator
where Flow == OnboardingCoordinatorFlow,
      Action == OnboardingCoordinatorAction
{

}