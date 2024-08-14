//
//  AuthDependencyFactoryInterface.swift
//
//  Auth
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import AuthCoordinator
import FCMDependencyFactory

import AuthData
import AuthDomain
import AuthPresenter

import FCMDomain

public protocol AuthDependencyFactory {
  
  func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any AuthCoordinator
  
  func makeAuthRepository() -> AuthRepository
  func makeSocialLoginUseCase() -> SocialLoginUseCase
  func makeAuthReactor<T: AuthCoordinator>(
    coordinator: T,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase
  ) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
  
}
