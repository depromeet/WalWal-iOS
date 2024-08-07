//
//  OnboardingProfileReactor.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import OnboardingDomain
import OnboardingCoordinator
import DesignSystem

import ReactorKit

public enum OnboardingProfileReactorAction {
  case register(nickname: String, profile: ProfileCellModel, petType: String)
  case checkCondition(nickname: String, profile: ProfileCellModel)
}

public enum OnboardingProfileReactorMutation {
//  case invalidCondition(button: Bool, msg: String?)
  case buttonEnable(isEnable: Bool)
  case invalidNickname(message: String)
  case registerError(message: String)
}

public struct OnboardingProfileReactorState {
  public init() { }
  @Pulse public var invalidMessage: String = ""
  public var buttonEnable: Bool = false
  @Pulse public var errorMessage: String = ""
}

public protocol OnboardingProfileReactor:
  Reactor where Action == OnboardingProfileReactorAction,
                Mutation == OnboardingProfileReactorMutation,
                State == OnboardingProfileReactorState {
  var coordinator: any OnboardingCoordinator { get }
  
  init(
    coordinator: any OnboardingCoordinator,
    registerUseCase: any RegisterUseCase,
    nicknameValidUseCase: any NicknameValidUseCase,
    uploadImageUseCase: any UploadImageUseCase
  )
}

