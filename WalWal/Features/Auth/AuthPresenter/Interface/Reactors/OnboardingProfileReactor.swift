//
//  OnboardingProfileReactor.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AuthDomain
import AuthCoordinator

import ReactorKit

public enum OnboardingProfileReactorAction {
}

public enum OnboardingProfileReactorMutation {
}

public struct OnboardingProfileReactorState {
  public init() { }
}

public protocol OnboardingProfileReactor:
  Reactor where Action == OnboardingProfileReactorAction,
                Mutation == OnboardingProfileReactorMutation,
                State == OnboardingProfileReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(coordinator: any AuthCoordinator)
}

