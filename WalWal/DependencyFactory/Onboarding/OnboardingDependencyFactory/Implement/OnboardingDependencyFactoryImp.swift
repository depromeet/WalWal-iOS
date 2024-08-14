//
//  OnboardingDependencyFactoryImplement.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import OnboardingDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory

import WalWalNetwork

import BaseCoordinator
import OnboardingCoordinator
import OnboardingCoordinatorImp

import OnboardingData
import OnboardingDataImp
import OnboardingDomain
import OnboardingDomainImp
import OnboardingPresenter
import OnboardingPresenterImp

import AuthDomain
import FCMDomain

public class OnboardingDependencyFactoryImp: OnboardingDependencyFactory {
  
  public init() { }
  
  public func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory
  )
  -> any OnboardingCoordinator {
    return OnboardingCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      onboardingDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory
    )
  }
  
  public func injectOnboardingRepository() -> OnboardingRepository {
    let networkService = NetworkService()
    return OnboardingRepositoryImp(networkService: networkService)
  }
  
  
  public func injectNicknameValidUseCase() -> NicknameValidUseCase {
    return NicknameValidUseCaseImp(repository: injectOnboardingRepository())
  }
  
  public func injectUploadImageUseCase() -> UploadImageUseCase {
    return UploadImageUseCaseImp(onboardingRepository: injectOnboardingRepository())
  }
  
  public func injectOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor {
    return OnboardingReactorImp(coordinator: coordinator)
  }
  
  public func injectOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor {
    return OnboardingSelectReactorImp(coordinator: coordinator)
  }
  
  public func injectOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    registerUseCase: RegisterUseCase
  ) -> any OnboardingProfileReactor {
    return OnboardingProfileReactorImp(
      coordinator: coordinator,
      registerUseCase: registerUseCase,
      nicknameValidUseCase: injectNicknameValidUseCase(),
      uploadImageUseCase: injectUploadImageUseCase(),
      fcmSaveUseCase: fcmSaveUseCase
    )
  }
  
  public func injectOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController {
    return OnboardingViewControllerImp(reactor: reactor)
  }
  
  public func injectOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController {
    return OnboardingSelectViewControllerImp(reactor: reactor)
  }
  
  public func injectOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController {
    return OnboardingProfileViewControllerImp(reactor: reactor, petType: petType)
  }
}
