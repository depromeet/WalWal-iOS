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
import FCMDomain
import ImageDomain
import AuthDomain
import MembersDomain

import ReactorKit

public enum OnboardingProfileReactorAction {
  case register(nickname: String, profile: WalWalProfileModel, petType: String)
  case checkCondition(nickname: String, profile: WalWalProfileModel)
  case checkPhotoPermission
  case tapBackButton
}

public enum OnboardingProfileReactorMutation {
  case buttonEnable(isEnable: Bool)
  case invalidNickname(message: String)
  case registerError(message: String)
  case showIndicator(show: Bool)
  case setPhotoPermission(isAllow: Bool)
  case moveToBack
}

public struct OnboardingProfileReactorState {
  public init() { }
  @Pulse public var invalidMessage: String = ""
  @Pulse public var isGrantedPhoto: Bool = false
  @Pulse public var errorMessage: String = ""
  public var buttonEnable: Bool = false
  public var showIndicator: Bool = false
  
}

public protocol OnboardingProfileReactor:
  Reactor where Action == OnboardingProfileReactorAction,
                Mutation == OnboardingProfileReactorMutation,
                State == OnboardingProfileReactorState {
  var coordinator: any OnboardingCoordinator { get }
  
  init(
    coordinator: any OnboardingCoordinator,
    registerUseCase: any RegisterUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase,
    checkNicknameUseCase: CheckNicknameUseCase
  )
}

