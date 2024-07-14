//
//  AuthAppDelegate.swift
//
//  Auth
//
//  Created by Jiyeon on .
//

import UIKit

import AuthPresenterView
import AuthPresenterReactor

@main
final class AuthAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = AuthViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  
}


