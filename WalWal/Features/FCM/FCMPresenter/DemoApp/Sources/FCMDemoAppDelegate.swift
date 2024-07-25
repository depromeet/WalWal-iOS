//
//  FCMAppDelegate.swift
//
//  FCM
//
//  Created by Jiyeon on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import FCMData
import FCMDomain
import FCMCoordinator
import FCMPresenter

@main
final class FCMAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeFCMReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeFCMViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}

