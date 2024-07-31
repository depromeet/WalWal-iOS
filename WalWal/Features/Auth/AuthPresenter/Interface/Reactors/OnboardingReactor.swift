//
//  OnboardingReactor.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import AuthDomain
import AuthCoordinator

import ReactorKit

public enum OnboardingReactorAction {
  case nextButtonTapped(flow: AuthCoordinatorFlow)
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
  var coordinator: any AuthCoordinator { get }
  
  init(coordinator: any AuthCoordinator)
}
