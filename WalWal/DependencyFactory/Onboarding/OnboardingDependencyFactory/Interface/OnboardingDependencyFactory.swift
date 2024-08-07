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

import AuthData
import OnboardingData
import OnboardingDomain
import OnboardingPresenter

public protocol OnboardingDependencyFactory {
  
  func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?
  ) -> any OnboardingCoordinator
  
  func makeAuthData() -> AuthRepository
  
  func makeRegisterUseCase() -> RegisterUseCase
  
  func makeOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor
  func makeOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor
  func makeOnboardingProfileReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingProfileReactor
  
  func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  func makeOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController
  func makeOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController
  
}
