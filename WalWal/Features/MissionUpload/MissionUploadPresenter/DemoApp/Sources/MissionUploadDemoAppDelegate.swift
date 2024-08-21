//
//  MissionUploadAppDelegate.swift
//
//  MissionUpload
//
//  Created by 조용인 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import MissionUploadData
import MissionUploadDomain
import MissionUploadCoordinator
import MissionUploadPresenter

@main
final class MissionUploadAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeMissionUploadReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeMissionUploadViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


