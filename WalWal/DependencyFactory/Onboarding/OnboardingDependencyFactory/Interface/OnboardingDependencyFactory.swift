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
import AuthDependencyFactory

import AuthData
import OnboardingData
import OnboardingDomain
import OnboardingPresenter

import FCMDomain
import AuthDomain

public protocol OnboardingDependencyFactory {
  
  func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory
  ) -> any OnboardingCoordinator
  
  func injectOnboardingRepository() -> OnboardingRepository
  
  func injectNicknameValidUseCase() -> NicknameValidUseCase
  func injectUploadImageUseCase() -> UploadImageUseCase
  
  func injectOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func injectOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func injectOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    registerUseCase: RegisterUseCase
  ) -> any OnboardingProfileReactor
  
  func injectOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func injectOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func injectOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
