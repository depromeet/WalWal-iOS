//
//  OnboardingReactor.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import OnboardingDomain
import OnboardingCoordinator

import ReactorKit
import RxSwift

public enum OnboardingReactorAction {
  case nextButtonTapped(flow: OnboardingCoordinatorFlow)
}

public enum OnboardingReactorMutation {
  
}

public struct OnboardingReactorState {
  public init() {
    
  }
}

public protocol OnboardingReactor: Reactor
where Action == OnboardingReactorAction,
      Mutation == OnboardingReactorMutation,
      State == OnboardingReactorState {
  
  var coordinator: any OnboardingCoordinator { get }
  
  init(
    coordinator: any OnboardingCoordinator
  )
}
