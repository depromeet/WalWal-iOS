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

import AuthData
import AuthDomain
import AuthPresenter

import FCMData
import FCMDomain

public protocol AuthDependencyFactory {
  
  func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any AuthCoordinator
  
  func makeAuthData() -> AuthRepository
  func makeSocialLoginUseCase() -> SocialLoginUseCase
  func makeAuthReactor<T: AuthCoordinator>(coordinator: T) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
  
  // MARK: - FCM
  
  func makeFCMData() -> FCMRepository
  func makeFCMSaveUseCase() -> FCMSaveUseCase
}
