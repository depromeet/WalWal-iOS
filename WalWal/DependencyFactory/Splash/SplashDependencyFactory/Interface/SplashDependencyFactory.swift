//
//  SplashDependencyFactoryInterface.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit

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

import AppCoordinator

import SplashDomain
import SplashPresenter

import FCMDomain

import RecordsDomain
import MembersDomain

public protocol SplashDependencyFactory {
  
  func injectAppCoordinator(
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
    memberDependencyFactory: MembersDependencyFactory
  ) -> any AppCoordinator
  
  func injectCheckTokenUseCase() -> CheckTokenUsecase
  
  func injectCheckIsFirstLoadedUseCase() -> CheckIsFirstLoadedUseCase
  
  func injectSplashReactor<T: AppCoordinator>(
    coordinator: T,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any SplashReactor
  
  func injectSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController
}
