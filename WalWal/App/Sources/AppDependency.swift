//
//  AppDependency.swift
//  WalWal
//
//  Created by 조용인 on 8/7/24.
//

import UIKit
import SplashDependencyFactoryImp
import AuthDependencyFactoryImp
import WalWalTabBarDependencyFactoryImp
import MissionDependencyFactoryImp
import MyPageDependencyFactoryImp
import AppCoordinator

extension AppDelegate {
  func injectWalWalImplement(navigation: UINavigationController) -> any AppCoordinator {
    /// 전체 의존성 구현체를 이곳에서 한번에 정의
    let splashDependencyFactory = SplashDependencyFactoryImp()
    let authDependencyFactory = AuthDependencyFactoryImp()
    let walwalTabBarDependencyFactory = WalWalTabBarDependencyFactoryImp()
    let missionDependencyFactory = MissionDependencyFactoryImp()
    let myPageDependencyFactory = MyPageDependencyFactoryImp()
    
    return splashDependencyFactory.makeAppCoordinator(
      navigationController: navigation,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory
    )
  }
}
