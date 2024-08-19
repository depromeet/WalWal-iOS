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
    imageDependencyFactory: ImageDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    memberDependencyFactory: MembersDependencyFactory
  ) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      appDependencyFactory: self,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      onboardingDependencyFactory: onboardingDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory,
      memberDependencyFactory: memberDependencyFactory
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
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any SplashReactor {
    return SplashReactorImp(
      coordinator: coordinator,
      checkTokenUseCase: checkTokenUseCase,
      checkIsFirstLoadedUseCase: checkIsFirstLoadedUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase,
      removeGlobalCalendarRecordsUseCase: removeGlobalCalendarRecordsUseCase,
      memberInfoUseCase: memberInfoUseCase
    )
  }
  
  public func injectSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController {
    return SplashViewControllerImp(reactor: reactor)
  }
}
