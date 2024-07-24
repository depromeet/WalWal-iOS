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
//    coordinator.start()
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: coordinator)
    let vc = dependencyFactory.makeOnboardingProfileViewController(reactor: reactor)
    window.rootViewController = UINavigationController(rootViewController: vc)//coordinator.navigationController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


