//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit

import SplashDependencyFactoryImp
import AuthDependencyFactoryImp
import WalWalTabBarDependencyFactoryImp
import MissionDependencyFactoryImp

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    /// 전체 의존성 구현체를 이곳에서 한번에 정의
    let splashDependencyFactory = SplashDependencyFactoryImp()
    let authDependencyFactory = AuthDependencyFactoryImp()
    let walwalTabBarDependencyFactory = WalWalTabBarDependencyFactoryImp()
    let missionDependencyFactory = MissionDependencyFactoryImp()
    
    let navigationController = UINavigationController()
    
    /// 최상단 코디네이터인 AppCoordinator에 모든 의존성의 인터페이스 주입
    let appCoordinator = splashDependencyFactory.makeAppCoordinator(
      navigationController: navigationController,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory
    )
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    appCoordinator.start()
    
    return true
  }
}

