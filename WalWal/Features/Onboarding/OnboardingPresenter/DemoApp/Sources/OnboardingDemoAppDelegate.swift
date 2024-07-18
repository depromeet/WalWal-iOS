//
//  OnboardingAppDelegate.swift
//
//  Onboarding
//
//  Created by Jiyeon on .
//

import UIKit
import OnboardingDependencyFactoryImp

@main
final class OnboardingAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = OnboardingDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeOnboardingCoordinator(navigationController: navigationController, parentCoordinator: nil)
    coordinator.start()
    window.rootViewController = coordinator.navigationController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


