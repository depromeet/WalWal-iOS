//
//  MyPageAppDelegate.swift
//
//  MyPage
//
//  Created by 조용인 on .
//

import UIKit

import MyPageDependencyFactory
import MyPageDependencyFactoryImp
import MyPageData
import MyPageDomain
import MyPageCoordinator
import MyPagePresenter

@main
final class MyPageAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = MyPageDependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.makeMyPageCoordinator(
      navigationController: navigationController,
      parentCoordinator: nil
    )
    let reactor = dependencyFactory.injectMyPageReactor(coordinator: coordinator)
    let viewController = dependencyFactory.injectMyPageViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


