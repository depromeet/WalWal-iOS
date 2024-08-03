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
  case checkNickname(_ nickname: String)
}

public enum OnboardingProfileReactorMutation {
  case invalidNickname(message: String)
}

public struct OnboardingProfileReactorState {
  public init() { }
  @Pulse public var invalidMessage: String = ""
}

public protocol OnboardingProfileReactor:
  Reactor where Action == OnboardingProfileReactorAction,
                Mutation == OnboardingProfileReactorMutation,
                State == OnboardingProfileReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(coordinator: any AuthCoordinator)
}

