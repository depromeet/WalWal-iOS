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

import FCMDomain

public class OnboardingDependencyFactoryImp: OnboardingDependencyFactory {
  
  public init() { }
  
  public func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory
  )
  -> any OnboardingCoordinator {
    return OnboardingCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      onboardingDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory
    )
  }
  
  public func makeAuthData() -> AuthRepository {
    let networkService = NetworkService()
    return AuthRepositoryImp(networkService: networkService)
  }
  
  public func makeOnboardingData() -> OnboardingRepository {
    let networkService = NetworkService()
    return OnboardingRepositoryImp(networkService: networkService)
  }
  
  public func makeRegisterUseCase() -> RegisterUseCase {
    return RegisterUseCaseImp(authRepository: makeAuthData())
  }
  
  public func makeNicknameValidUseCase() -> NicknameValidUseCase {
    return NicknameValidUseCaseImp(repository: makeOnboardingData())
  }
  
  public func makeUploadImageUseCase() -> UploadImageUseCase {
    return UploadImageUseCaseImp(onboardingRepository: makeOnboardingData())
  }
  
  public func makeOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor {
    return OnboardingReactorImp(coordinator: coordinator)
  }
  
  public func makeOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor {
    return OnboardingSelectReactorImp(coordinator: coordinator)
  }
  
  public func makeOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase
  ) -> any OnboardingProfileReactor {
    return OnboardingProfileReactorImp(
      coordinator: coordinator,
      registerUseCase: makeRegisterUseCase(),
      nicknameValidUseCase: makeNicknameValidUseCase(),
      uploadImageUseCase: makeUploadImageUseCase(),
      fcmSaveUseCase: fcmSaveUseCase
    )
  }
  
  public func makeOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController {
    return OnboardingViewControllerImp(reactor: reactor)
  }
  
  public func makeOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController {
    return OnboardingSelectViewControllerImp(reactor: reactor)
  }
  
  public func makeOnboardingProfileViewController<T: OnboardingProfileReactor>(reactor: T, petType: String) -> any OnboardingProfileViewController {
    return OnboardingProfileViewControllerImp(reactor: reactor, petType: petType)
  }
}
