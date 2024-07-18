//
//  OnboardingReactorImp.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import OnboardingDomain
import OnboardingPresenter
import OnboardingCoordinator

import ReactorKit
import RxSwift

public final class OnboardingReactorImp: OnboardingReactor {
  public typealias Action = OnboardingReactorAction
  public typealias Mutation = OnboardingReactorMutation
  public typealias State = OnboardingReactorState
  
  public let initialState: State
  public let coordinator: any OnboardingCoordinator
  
  public init(
    coordinator: any OnboardingCoordinator
  ) {
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
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
