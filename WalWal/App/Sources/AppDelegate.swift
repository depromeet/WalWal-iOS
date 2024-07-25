//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit
import SplashDependencyFactory
import SplashDependencyFactoryImp

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = SplashDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeAppCoordinator(navigationController: navigationController)
    coordinator.start()
    window.rootViewController = coordinator.baseViewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}

