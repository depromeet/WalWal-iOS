//
//  MissionAppDelegate.swift
//
//  Mission
//
//  Created by 이지희 on .
//

import UIKit

import MissionDependencyFactoryImp

@main
final class MissionAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = MissionDependencyFactoryImp()
    let navigationController = UINavigationController()
//    let coordinator = dependencyFactory.injectMissionCoordinator(
//      navigationController: navigationController,
//      parentCoordinator: nil,
//      recordDependencyFactory: recordde)
//    let reactor = dependencyFactory.injectMissionReactor(
//      coordinator: coordinator,
//      todayMissionUseCase: <#T##any TodayMissionUseCase#>,
//      checkCompletedTotalRecordsUseCase: <#T##any CheckCompletedTotalRecordsUseCase#>,
//      checkRecordStatusUseCase: <#T##any CheckRecordStatusUseCase#>,
//      startRecordUseCase: <#T##any StartRecordUseCase#>
//    )
//    let viewController = dependencyFactory.injectMissionViewController(reactor: reactor)
//    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


