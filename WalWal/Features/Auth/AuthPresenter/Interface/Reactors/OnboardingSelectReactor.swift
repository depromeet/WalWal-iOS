//
//  OnboardingSelectReactor.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AuthDomain
import AuthCoordinator

import ReactorKit

public enum OnboardingSelectReactorAction {
  case selectAnimal(dog: Bool, cat: Bool)
  case initSelectView
  case nextButtonTapped(flow: AuthCoordinatorFlow)
}

public enum OnboardingSelectReactorMutation {
  case selectAnimal(dog: Bool, cat: Bool)
  case selectCompleteButtonEnable(_ isEnable: Bool)
}

public struct OnboardingSelectReactorState {
  public init() { }
  public var selectedAnimal: (dog: Bool?, cat: Bool?) = (dog: nil, cat: nil)
  public var selectCompleteButtonEnable: Bool = false
}

public protocol OnboardingSelectReactor:
  Reactor where Action == OnboardingSelectReactorAction,
                Mutation == OnboardingSelectReactorMutation,
                State == OnboardingSelectReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(coordinator: any AuthCoordinator)
}