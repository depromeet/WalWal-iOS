//
//  OnboardingAppDelegate.swift
//
//  Onboarding
//
//  Created by Jiyeon on .
//

import UIKit

import OnboardingDependencyFactory
import OnboardingDependencyFactoryImp
import OnboardingData
import OnboardingDomain
import OnboardingCoordinator
import OnboardingPresenter

@main
final class OnboardingAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = OnboardingDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeOnboardingCoordinator(
      navigationController: navigationController,
      parentCoordinator: nil
    )
    let reactor = dependencyFactory.makeOnboardingProfileReactor(coordinator: coordinator)//makeOnboardingReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeOnboardingProfileViewController(reactor: reactor, petType: "DOG")//makeOnboardingViewController(reactor: reactor)
//    coordinator.start()
    window.rootViewController = viewController//coordinator.navigationController//viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


