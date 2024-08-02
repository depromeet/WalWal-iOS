//
//  OnboardingReactorImp.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AuthDomain
import AuthCoordinator
import AuthPresenter

import ReactorKit
import RxSwift

public final class OnboardingReactorImp: OnboardingReactor {
  public typealias Action = OnboardingReactorAction
  public typealias Mutation = OnboardingReactorMutation
  public typealias State = OnboardingReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  
  public init(coordinator: any AuthCoordinator) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .nextButtonTapped(flow):
      coordinator.destination.accept(flow)
      return .never()
    }
  }
  
  
}
