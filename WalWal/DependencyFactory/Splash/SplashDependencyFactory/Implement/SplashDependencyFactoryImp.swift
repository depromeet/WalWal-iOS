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
import MyPageDependencyFactory
import FCMDependencyFactory
import OnboardingDependencyFactory
import FeedDependencyFactory
import RecordsDependencyFactory

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

public class SplashDependencyFactoryImp: SplashDependencyFactory {
  
  public init() {
    
  }
  
  public func injectAppCoordinator(
    navigationController: UINavigationController,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory
  ) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      appDependencyFactory: self,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      onboardingDependencyFactory: onboardingDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory
    )
  }
  
  public func injectCheckTokenUseCase() -> CheckTokenUsecase {
    return CheckTokenUsecaseImp()
  }
  
  public func injectSplashReactor<T: AppCoordinator>(
    coordinator: T,
    checkTokenUseCase: CheckTokenUsecase,
    fcmSaveUseCase: FCMSaveUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  ) -> any SplashReactor {
    return SplashReactorImp(
      coordinator: coordinator,
      checkTokenUseCase: checkTokenUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase
    )
  }
  
  public func injectSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController {
    return SplashViewControllerImp(reactor: reactor)
  }
}
