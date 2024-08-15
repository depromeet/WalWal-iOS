//
//  FeedAppDelegate.swift
//
//  Feed
//
//  Created by 이지희 on .
//

import UIKit

import FeedDependencyFactory
import FeedDependencyFactoryImp
import FeedData
import FeedDomain
import FeedCoordinator
import FeedPresenter

@main
final class FeedAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = FeedDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeFeedCoordinator(navigationController: navigationController, parentCoordinator: nil)
    let reactor = dependencyFactory.makeFeedReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeFeedViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


