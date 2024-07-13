//
//  SampleAppDelegate.swift
//
//  Sample
//
//  Created by 조용인 on .
//

import UIKit

import SampleView
import SampleReactor

@main
final class SampleAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = SampleViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
  
}


