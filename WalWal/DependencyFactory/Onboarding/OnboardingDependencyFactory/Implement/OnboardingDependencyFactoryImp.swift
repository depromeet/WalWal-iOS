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
import ImageDependencyFactory
import AuthDependencyFactory

import WalWalNetwork

import BaseCoordinator
import OnboardingCoordinator
import OnboardingCoordinatorImp

import ImageDomainImp
import OnboardingData
import OnboardingDataImp
import OnboardingDomain
import OnboardingDomainImp
import OnboardingPresenter
import OnboardingPresenterImp

import AuthDomain
import FCMDomain
import ImageDomain

public class OnboardingDependencyFactoryImp: OnboardingDependencyFactory {
  
  public init() { }
  
  public func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    authDependencyFactory: AuthDependencyFactory
  )
  -> any OnboardingCoordinator {
    return OnboardingCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      onboardingDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependecyFactory: imageDependencyFactory,
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
  
  public func injectOnboardingReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingReactor {
    return OnboardingReactorImp(coordinator: coordinator)
  }
  
  public func injectOnboardingSelectReactor<T: OnboardingCoordinator>(coordinator: T) -> any OnboardingSelectReactor {
    return OnboardingSelectReactorImp(coordinator: coordinator)
  }
  
  public func injectOnboardingProfileReactor<T: OnboardingCoordinator>(
    coordinator: T,
    fcmSaveUseCase: FCMSaveUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    registerUseCase: RegisterUseCase,
    userTokensUseCase: UserTokensSaveUseCase
  ) -> any OnboardingProfileReactor {
    return OnboardingProfileReactorImp(
      coordinator: coordinator,
      registerUseCase: registerUseCase,
      nicknameValidUseCase: injectNicknameValidUseCase(),
      uploadMemberUseCase: uploadMemberUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      userTokensSaveUseCase: userTokensUseCase
    )
  }
  
  public func injectOnboardingViewController<T: OnboardingReactor>(reactor: T) -> any OnboardingViewController {
    return OnboardingViewControllerImp(reactor: reactor)
  }
  
  public func injectOnboardingSelectViewController<T: OnboardingSelectReactor>(reactor: T) -> any OnboardingSelectViewController {
    return OnboardingSelectViewControllerImp(reactor: reactor)
  }
  
  public func injectOnboardingProfileViewController<T: OnboardingProfileReactor>(
    reactor: T,
    petType: String
  ) -> any OnboardingProfileViewController {
    return OnboardingProfileViewControllerImp(reactor: reactor, petType: petType)
  }
}
