//
//  DependencyFactory.swift
//  DependencyFactory
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit

import BaseCoordinator
import AppCoordinator
import SampleAppCoordinator
import SampleAuthCoordinator
import SampleHomeCoordinator
import AuthCoordinator
import OnboardingCoordinator

import SplashData
import SplashDomain
import SplashPresenter

import SampleData
import SampleDomain
import SamplePresenter

import AuthData
import AuthDomain
import AuthPresenter

import OnboardingData
import OnboardingDomain
import OnboardingPresenter

public protocol DependencyFactory {
  
  // MARK: - Coordinators
  
  func makeAppCoordinator(navigationController: UINavigationController) -> any AppCoordinator
  func makeSampleAppCoordinator(navigationController: UINavigationController) -> any SampleAppCoordinator
  func makeSampleAuthCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleAuthCoordinator
  func makeSampleHomeCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleHomeCoordinator
  func makeAuthCoordinator(navigationController: UINavigationController) -> any AuthCoordinator
  func makeOnboardingCoordinator(navigationController: UINavigationController, parentCoordinator: (any BaseCoordinator)?) -> any OnboardingCoordinator
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수를 추가해주새요

  // MARK: - Sample
  
  func makeSampleAuthData() -> SampleAuthRepository
  
  func makeSampleSignInUsecase() -> SampleSignInUseCase
  func makeSampleSignUpUsecase() -> SampleSignUpUseCase
  
  func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor
  func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController
  
  // MARK: - Splash
  
  func makeSplashReactor(coordinator: any AppCoordinator) -> any SplashReactor
  func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController
  
  // MARK: - Auth
  
  func makeAuthData() -> AuthRepository
  func makeAppleLoginUseCase() -> AppleLoginUseCase
  func makeAuthReactor(coordinator: any AuthCoordinator) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
 
  // MARK: - OnBoarding
  
  func makeOnboardingReactor(coordinator: any OnboardingCoordinator) -> any OnboardingReactor
  func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController
  
}

