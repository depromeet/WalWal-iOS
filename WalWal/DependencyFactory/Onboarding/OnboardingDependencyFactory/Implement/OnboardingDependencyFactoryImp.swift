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
import MembersDependencyFactory

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
import ImageDomain
import MembersDomain

public class OnboardingDependencyFactoryImp: OnboardingDependencyFactory {
  
  public init() { }
  
  public func makeOnboardingCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  )
  -> any OnboardingCoordinator {
    return OnboardingCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      onboardingDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependecyFactory: imageDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory
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
    userTokensUseCase: UserTokensSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any OnboardingProfileReactor {
    return OnboardingProfileReactorImp(
      coordinator: coordinator,
      registerUseCase: registerUseCase,
      nicknameValidUseCase: injectNicknameValidUseCase(),
      uploadMemberUseCase: uploadMemberUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      userTokensSaveUseCase: userTokensUseCase,
      memberInfoUseCase: memberInfoUseCase
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
