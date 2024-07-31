//
//  OnboardingProfileReactor.swift
//  AuthPresenterImp
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AuthDomain
import AuthCoordinator
import AuthPresenter

import ReactorKit
import RxSwift

public final class OnboardingProfileReactorImp: OnboardingProfileReactor {
  public typealias Action = OnboardingProfileReactorAction
  public typealias Mutation = OnboardingProfileReactorMutation
  public typealias State = OnboardingProfileReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  
  public init(coordinator: any AuthCoordinator) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    }
  }
}

