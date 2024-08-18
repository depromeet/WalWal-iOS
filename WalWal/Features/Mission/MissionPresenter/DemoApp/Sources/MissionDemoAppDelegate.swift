//
//  MissionAppDelegate.swift
//
//  Mission
//
//  Created by 이지희 on .
//

import UIKit

import MissionDependencyFactoryImp

@main
final class MissionAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = MissionDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.injectMissionCoordinator(navigationController: navigationController, parentCoordinator: nil)
    let reactor = dependencyFactory.injectMissionReactor(coordinator: coordinator, todayMissionUseCase: dependencyFactory.injectTodayMissionUseCase())
    let viewController = dependencyFactory.injectMissionViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


