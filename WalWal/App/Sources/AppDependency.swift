//
//  AppDependency.swift
//  WalWal
//
//  Created by 조용인 on 8/7/24.
//

import UIKit
import AppCoordinator
import SplashDependencyFactoryImp
import AuthDependencyFactoryImp
import WalWalTabBarDependencyFactoryImp
import MissionDependencyFactoryImp
import MyPageDependencyFactoryImp
import OnboardingDependencyFactoryImp
import FeedDependencyFactoryImp
import FCMDependencyFactoryImp
import RecordsDependencyFactoryImp
import ImageDependencyFactoryImp

extension AppDelegate {
  func injectWalWalImplement(navigation: UINavigationController) -> any AppCoordinator {
    /// 전체 의존성 구현체를 이곳에서 한번에 정의
    let splashDependencyFactory = SplashDependencyFactoryImp()
    let authDependencyFactory = AuthDependencyFactoryImp()
    let walwalTabBarDependencyFactory = WalWalTabBarDependencyFactoryImp()
    let missionDependencyFactory = MissionDependencyFactoryImp()
    let myPageDependencyFactory = MyPageDependencyFactoryImp()
    let fcmDependencyFactory = FCMDependencyFactoryImp()
    let onboardingDependencyFactory = OnboardingDependencyFactoryImp()
    let feedDependencyFactory = FeedDependencyFactoryImp()
    let recordsDependencyFactory = RecordsDependencyFactoryImp()
    let imageDependencyFactory = ImageDependencyFactoryImp()
    
    return splashDependencyFactory.injectAppCoordinator(
      navigationController: navigation,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      onboardingDependencyFactory: onboardingDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory
    )
  }
}
