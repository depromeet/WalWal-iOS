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
import Utility

import ReactorKit
import RxSwift
import Foundation

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
    case let .checkNickname(nickname):
      if nickname.count > 14 {
        return .just(.invalidNickname(message: "14글자 이내로 입력해주세요"))
      }
      else if !nickname.isValidNickName() {
        return .just(.invalidNickname(message: "영문, 한글만 입력할 수 있어요"))
      }
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .invalidNickname(message):
      newState.invalidMessage = message
    }
    return newState
  }
}


