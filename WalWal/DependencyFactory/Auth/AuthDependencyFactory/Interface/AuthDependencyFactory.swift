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

public protocol AuthDependencyFactory {
  func makeAuthData() -> AuthRepository
  func makeSocialLoginUseCase() -> SocialLoginUseCase
  func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any AuthCoordinator
  func makeAuthReactor<T: AuthCoordinator>(coordinator: T) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
}
