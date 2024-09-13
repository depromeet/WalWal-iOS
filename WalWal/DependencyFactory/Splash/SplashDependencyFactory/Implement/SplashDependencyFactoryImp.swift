//
//  SplashDependencyFactoryImplement.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit
import SplashDependencyFactory
import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MissionUploadDependencyFactory
import MyPageDependencyFactory
import FCMDependencyFactory
import ImageDependencyFactory
import OnboardingDependencyFactory
import FeedDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory

import WalWalNetwork

import BaseCoordinator
import AppCoordinator
import AppCoordinatorImp

import SplashData
import SplashDataImp
import SplashDomain
import SplashDomainImp
import SplashPresenter
import SplashPresenterImp

import FCMDomain
import RecordsDomain
import MembersDomain

import RxSwift

public class SplashDependencyFactoryImp: SplashDependencyFactory {
  
  public init() {
    
  }
  
  public func injectAppCoordinator(
    navigationController: UINavigationController,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    memberDependencyFactory: MembersDependencyFactory,
    deepLinkObservable: Observable<String?>
  ) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      appDependencyFactory: self,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory, 
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      onboardingDependencyFactory: onboardingDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory,
      memberDependencyFactory: memberDependencyFactory,
      deepLinkObservable: deepLinkObservable
    )
  }
  
  public func injectCheckTokenUseCase() -> CheckTokenUsecase {
    return CheckTokenUsecaseImp()
  }
  
  public func injectCheckIsFirstLoadedUseCase() -> CheckIsFirstLoadedUseCase {
    return CheckIsFirstLoadedUseCaseImp()
  }
  
  public func injectSplashReactor<T: AppCoordinator>(
    coordinator: T,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any SplashReactor {
    return SplashReactorImp(
      coordinator: coordinator,
      checkTokenUseCase: checkTokenUseCase,
      checkIsFirstLoadedUseCase: checkIsFirstLoadedUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      memberInfoUseCase: memberInfoUseCase
    )
  }
  
  public func injectSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController {
    return SplashViewControllerImp(reactor: reactor)
  }
}
