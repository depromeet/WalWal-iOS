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

import FCMData
import FCMDataImp
import FCMDomain
import FCMDomainImp

public class AuthDependencyFactoryImp: AuthDependencyFactory {
  
  public init() { }
  
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
  
  public func makeSocialLoginUseCase() -> SocialLoginUseCase {
    return SocialLoginUseCaseImp(authDataRepository: makeAuthData())
  }
  
  public func makeAuthReactor<T: AuthCoordinator>(coordinator: T) -> any AuthReactor {
    return AuthReactorImp(
      coordinator: coordinator,
      socialLoginUseCase: makeSocialLoginUseCase(),
      fcmSaveUseCase: makeFCMSaveUseCase()
    )
  }
  
  public func makeAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController {
    return AuthViewControllerImp(reactor: reactor)
  }
  
  // MARK: - FCM
  
  public func makeFCMData() -> FCMRepository {
    let networkService = NetworkService()
    return FCMRepositoryImp(networkService: networkService)
  }
  
  public func makeFCMSaveUseCase() -> FCMSaveUseCase {
    return FCMSaveUseCaseImp(fcmRepository: makeFCMData())
  }
}
