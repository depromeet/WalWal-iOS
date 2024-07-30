//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit

import SplashDependencyFactory
import SplashDependencyFactoryImp

import AppCoordinator
import AppCoordinatorImp

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let dependencyFactory = SplashDependencyFactoryImp()
    let navigationController = UINavigationController()
    /// AppCoordinator 생성 및 시작
    /// 나중에는 여기서 의존성 다 주입
    /// ```
    /// dependencyFactory.makeAppCoordinator(
    ///     navigationController: navigationController,
    ///     walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
    /// )
    /// ```
    let appCoordinator = dependencyFactory.makeAppCoordinator(navigationController: navigationController)
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    appCoordinator.start()
    
    return true
  }
}

