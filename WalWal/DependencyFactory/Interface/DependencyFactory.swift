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

import SplashData
import SplashDomain
import SplashPresenter

import SampleData
import SampleDomain
import SamplePresenter

import AuthCoordinator

import AuthData
import AuthDomain
import AuthPresenter

public protocol DependencyFactory {
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수를 추가해주새요
  
  /// Sample Features
  func makeSampleAuthData() -> SampleAuthRepository
  
  func makeSampleSignInUsecase() -> SampleSignInUseCase
  func makeSampleSignUpUsecase() -> SampleSignUpUseCase
  
  func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor
  func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController
  
  func makeSplashReactor(coordinator: any AppCoordinator) -> any SplashReactor
  func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController
  
  func makeAppCoordinator(navigationController: UINavigationController) -> any AppCoordinator

  /// Sample Coordinaotrs
  func makeSampleAppCoordinator(navigationController: UINavigationController) -> any SampleAppCoordinator
  
  func makeSampleAuthCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleAuthCoordinator
  
  func makeSampleHomeCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleHomeCoordinator
  
  // MARK: - Auth
  
  func makeAuthData() -> AuthDataRepository
  func makeAuthUsecase() -> AuthUseCase
  func makeAuthReactor(coordinator: any AuthCoordinator) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
  func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any AuthCoordinator
  
  
}

