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
  
  func makeOnboardingData() -> OnboardingRepository
  
//  func makeRegisterUseCase() -> RegisterUseCase
  func makeNicknameValidUseCase() -> NicknameValidUseCase
  func makeUploadImageUseCase() -> UploadImageUseCase
  
  func makeOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func makeOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func makeOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    registerUseCase: RegisterUseCase
  ) -> any OnboardingProfileReactor
  
  func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func makeOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func makeOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
