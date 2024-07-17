//
//  MissionAppDelegate.swift
//
//  Mission
//
//  Created by 이지희 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import MissionData
import MissionDomain
import MissionCoordinator
import MissionPresenter

@main
final class MissionAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeMissionCoordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeMissionReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeMissionViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


