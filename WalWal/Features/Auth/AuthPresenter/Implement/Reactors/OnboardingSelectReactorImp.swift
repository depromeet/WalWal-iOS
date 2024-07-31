//
//  OnboardingSelectReactorImp.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import AuthPresenter
import AuthDomain
import AuthCoordinator

import ReactorKit
import RxSwift

public final class OnboardingSelectReactorImp: OnboardingSelectReactor {
  public typealias Action = OnboardingSelectReactorAction
  public typealias Mutation = OnboardingSelectReactorMutation
  public typealias State = OnboardingSelectReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  
  public init(coordinator: any AuthCoordinator) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .selectAnimal(dog, cat):
      return .concat([
        .just(.selectAnimal(dog: dog, cat: cat)),
        .just(.selectCompleteButtonEnable(dog || cat))
      ])
    case .initSelectView:
      return .concat([
        .just(.selectAnimal(dog: false, cat: false)),
        .just(.selectCompleteButtonEnable(false))
      ])
    case let .nextButtonTapped(flow):
      coordinator.destination.onNext(flow)
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .selectAnimal(dog, cat):
      newState.selectedAnimal = (dog, cat)
    case let .selectCompleteButtonEnable(isEnable):
      newState.selectCompleteButtonEnable = isEnable
    }
    return newState
  }

}
