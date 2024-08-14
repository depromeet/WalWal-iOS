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

import AuthData
import OnboardingData
import OnboardingDomain
import OnboardingPresenter

import FCMDomain

public protocol OnboardingDependencyFactory {
  
  func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any OnboardingCoordinator
  
  func makeAuthData() -> AuthRepository
  func makeOnboardingData() -> OnboardingRepository
  
  func makeRegisterUseCase() -> RegisterUseCase
  func makeNicknameValidUseCase() -> NicknameValidUseCase
  func makeUploadImageUseCase() -> UploadImageUseCase
  
  func makeOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func makeOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func makeOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase
  ) -> any OnboardingProfileReactor
  
  func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func makeOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func makeOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
