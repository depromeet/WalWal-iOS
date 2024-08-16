//
//  OnboardingReactor.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import OnboardingDomain
import OnboardingCoordinator

import ReactorKit

public enum OnboardingReactorAction {
  case nextButtonTapped(flow: OnboardingCoordinatorFlow)
}

public enum OnboardingReactorMutation {
  
}

public struct OnboardingReactorState {
  public init() { }
}

public protocol OnboardingReactor:
  Reactor where Action == OnboardingReactorAction,
                Mutation == OnboardingReactorMutation,
                State == OnboardingReactorState {
  var coordinator: any OnboardingCoordinator { get }
  
  init(coordinator: any OnboardingCoordinator)
}
