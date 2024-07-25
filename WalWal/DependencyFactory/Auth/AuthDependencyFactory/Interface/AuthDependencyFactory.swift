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
  func makeAppleLoginUseCase() -> AppleLoginUseCase
  func makeAuthReactor(coordinator: any AuthCoordinator) -> any AuthReactor
  func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController
  func makeAuthCoordinator(navigationController: UINavigationController) -> any AuthCoordinator
}
