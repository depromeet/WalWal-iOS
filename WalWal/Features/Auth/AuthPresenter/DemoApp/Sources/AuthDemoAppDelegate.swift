//
//  AuthAppDelegate.swift
//
//  Auth
//
//  Created by Jiyeon on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import AuthData
import AuthDomain
import AuthCoordinator
import AuthPresenter

@main
final class AuthAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeAuthCoordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeAuthReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeAuthViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


