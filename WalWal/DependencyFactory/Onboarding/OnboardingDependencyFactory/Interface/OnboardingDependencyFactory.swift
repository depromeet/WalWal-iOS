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

import AuthData
import OnboardingData
import OnboardingDomain
import OnboardingPresenter

import FCMDomain
import ImageDomain
import AuthDomain

public protocol OnboardingDependencyFactory {
  
  func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    authDependencyFactory: AuthDependencyFactory
  ) -> any OnboardingCoordinator
  
  func injectOnboardingRepository() -> OnboardingRepository
  
  func injectNicknameValidUseCase() -> NicknameValidUseCase
  
  func injectOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func injectOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func injectOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    registerUseCase: RegisterUseCase,
    userTokensUseCase: UserTokensSaveUseCase
  ) -> any OnboardingProfileReactor
  
  func injectOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func injectOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func injectOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
