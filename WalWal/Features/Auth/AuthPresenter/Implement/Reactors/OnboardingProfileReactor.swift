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
import DesignSystem

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
    case let .register(nickname, profile):
      print(nickname, profile)
      return .never()
    case let .checkCondition(nickname, profile):
      return checkValidForm(nickname: nickname, profile: profile)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .buttonEnable(isEnable):
      newState.buttonEnable = isEnable
    case let .invalidNickname(message):
      newState.invalidMessage = message
    }
    return newState
  }
}


extension OnboardingProfileReactorImp {
  private func checkValidForm(nickname: String, profile: ProfileCellModel) -> Observable<Mutation> {
    if nickname.count < 2 {
      return .just(.buttonEnable(isEnable: false))
    }
    else if nickname.count > 14 {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: "14글자 이내로 입력해주세요"))
      ])
    } else if !nickname.isValidNickName() {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: "영문, 한글만 입력할 수 있어요"))
      ])
    } else if profile.profileType == .selectImage && profile.curImage == nil {
      return .just(.buttonEnable(isEnable: false))
    } else {
      return .just(.buttonEnable(isEnable: true))
    }
  }
  
}
