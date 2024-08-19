//
//  MembersAppDelegate.swift
//
//  Members
//
//  Created by Jiyeon on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import MembersData
import MembersDomain
import MembersCoordinator
import MembersPresenter

@main
final class MembersAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeMembersReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeMembersViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


