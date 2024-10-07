//
//  CommentAppDelegate.swift
//
//  Comment
//
//  Created by 조용인 on .
//

import UIKit

import DependencyFactory
import DependencyFactoryImp
import CommentData
import CommentDomain
import CommentCoordinator
import CommentPresenter

@main
final class CommentAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = DependencyFactoryImp()
    let navigationController = UINavigationController()
    let coordinator = dependencyFactory.make__Coordinator(navigationController: navigationController)
    let reactor = dependencyFactory.makeCommentReactor(coordinator: coordinator)
    let viewController = dependencyFactory.makeCommentViewController(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


