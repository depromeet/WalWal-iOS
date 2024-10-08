//
//  RecordsAppDelegate.swift
//
//  Records
//
//  Created by 조용인 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import RecordsData
import RecordsDomain
import RecordsCoordinator
import RecordsPresenter

@main
final class RecordsAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeRecordsReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeRecordsViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


