//
//  SampleAppDelegate.swift
//
//  Sample
//
//  Created by 조용인 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import SampleData
import SampleDomain
import SampleAppCoordinator
import SamplePresenter

@main
final class SampleAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeSampleAppCoordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeSampleReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeSampleViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  
}


