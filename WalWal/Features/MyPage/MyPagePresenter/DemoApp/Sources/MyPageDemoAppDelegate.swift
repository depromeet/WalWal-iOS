//
//  MyPageAppDelegate.swift
//
//  MyPage
//
//  Created by 조용인 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import MyPageData
import MyPageDomain
import MyPageCoordinator
import MyPagePresenter

@main
final class MyPageAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeMyPageReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeMyPageViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


