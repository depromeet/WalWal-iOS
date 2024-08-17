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
  
  func injectAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any AuthCoordinator
  
  func injectAuthRepository() -> AuthRepository
  func injectSocialLoginUseCase() -> SocialLoginUseCase
  func injectRegisterUseCase() -> RegisterUseCase
  func injectUserTokensUseCase() -> UserTokensSaveUseCase
  func injectTokenDeleteUseCase() -> TokenDeleteUseCase
  func injectKakaoLogoutUseCase() -> KakaoLogoutUseCase
  
  func injectAuthReactor<T: AuthCoordinator>(
    coordinator: T,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase
  ) -> any AuthReactor
  func injectAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
  
}
