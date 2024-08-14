//
//  AuthDependencyFactoryImplement.swift
//
//  Auth
//
//  Created by 조용인
//

import UIKit
import AuthDependencyFactory
import FCMDependencyFactory

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

import FCMDomain

public class AuthDependencyFactoryImp: AuthDependencyFactory {
  
  public init() { }
  
  public func makeAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any AuthCoordinator {
    return AuthCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      authDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory
    )
  }
  
  public func makeAuthRepository() -> AuthRepository {
    let networkService = NetworkService()
    return AuthRepositoryImp(networkService: networkService)
  }
  
  public func makeSocialLoginUseCase() -> SocialLoginUseCase {
    return SocialLoginUseCaseImp(authDataRepository: makeAuthRepository())
  }
  
  public func makeAuthReactor<T: AuthCoordinator>(
    coordinator: T,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase
  ) -> any AuthReactor {
    return AuthReactorImp(
      coordinator: coordinator,
      socialLoginUseCase: socialLoginUseCase,
      fcmSaveUseCase: fcmSaveUseCase
    )
  }
  
  public func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController {
    return AuthViewControllerImp(reactor: reactor)
  }
  
}
