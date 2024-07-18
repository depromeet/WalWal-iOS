//
//  OnboardingDependencyFactoryImplement.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import OnboardingDependencyFactory

import WalWalNetwork

import BaseCoordinator
import OnboardingCoordinator
import OnboardingCoordinatorImp

import AuthData
import AuthDataImp

import OnboardingData
import OnboardingDataImp
import OnboardingDomain
import OnboardingDomainImp
import OnboardingPresenter
import OnboardingPresenterImp

public class OnboardingDependencyFactoryImp: OnboardingDependencyFactory {
  
  public init() { }
  
  public func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?) 
  -> any OnboardingCoordinator {
    return OnboardingCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      onboardingDependencyFactory: self
    )
  }
  
  public func makeAuthData() -> AuthRepository {
    let networkService = NetworkService()
    return AuthRepositoryImp(networkService: networkService)
  }
  
  public func makeOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor {
    return OnboardingReactorImp(coordinator: coordinator)
  }
  
  public func makeOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor {
    return OnboardingSelectReactorImp(coordinator: coordinator)
  }
  
  public func makeOnboardingProfileReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingProfileReactor {
    return OnboardingProfileReactorImp(coordinator: coordinator)
  }
  
  public func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController {
    return OnboardingViewControllerImp(reactor: reactor)
  }
  
  public func makeOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController {
    return OnboardingSelectViewControllerImp(reactor: reactor)
  }
  
  public func makeOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T) -> any OnboardingProfileViewController {
    return OnboardingProfileViewControllerImp(reactor: reactor)
  }
}
