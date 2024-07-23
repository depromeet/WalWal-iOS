//
//  SplashAppDelegate.swift
//
//  Splash
//
//  Created by 조용인 on .
//

import UIKit
import DependencyFactoryImp

@main
final class SplashAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeAppCoordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeSplashReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeSplashViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


