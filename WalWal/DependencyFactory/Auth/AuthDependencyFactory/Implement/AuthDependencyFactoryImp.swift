//
//  AuthDependencyFactoryImplement.swift
//
//  Auth
//
//  Created by 조용인
//

import UIKit
import AuthDependencyFactory

import WalWalNetwork

import BaseCoordinator
import AuthCoordinator
import AuthCoordinatorImp

import AuthData
import AuthDataImp
import AuthDomain
import AuthDomainImp
import AuthPresenter
import AuthPresenterImp

public class AuthDependencyFactoryImp: AuthDependencyFactory {
  
  public init() {
    
  }
  
  public func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any AuthCoordinator {
    return AuthCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      authDependencyFactory: self
    )
  }
  
  public func makeAuthData() -> AuthRepository {
    let networkService = NetworkService()
    return AuthRepositoryImp(networkService: networkService)
  }
  
  public func makeAppleLoginUseCase() -> AppleLoginUseCase {
    return AppleLoginUseCaseImp(authDataRepository: makeAuthData())
  }
  
  public func makeAuthReactor<T: AuthCoordinator>(coordinator: T) -> any AuthReactor {
    return AuthReactorImp(
      coordinator: coordinator,
      appleLoginUseCase: makeAppleLoginUseCase()
    )
  }
  
  public func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController {
    return AuthViewControllerImp(reactor: reactor)
  }
}
