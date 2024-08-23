//
//  OnboardingDependencyFactoryInterface.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import BaseCoordinator
import OnboardingCoordinator
import FCMDependencyFactory
import ImageDependencyFactory
import AuthDependencyFactory
import MembersDependencyFactory

import AuthData
import OnboardingData
import OnboardingDomain
import OnboardingPresenter

import FCMDomain
import ImageDomain
import AuthDomain
import MembersDomain

public protocol OnboardingDependencyFactory {
  
  func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) -> any OnboardingCoordinator
  
  func injectOnboardingRepository() -> OnboardingRepository
  
  func injectOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func injectOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func injectOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    registerUseCase: RegisterUseCase,
    userTokensUseCase: UserTokensSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase,
    checkNicknameUseCase: CheckNicknameUseCase
  ) -> any OnboardingProfileReactor
  
  func injectOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func injectOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func injectOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
