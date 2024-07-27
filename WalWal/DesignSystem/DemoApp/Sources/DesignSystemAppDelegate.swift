//
//  DesignSystemAppDelegate.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

@main
final class DesignSystemAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    window.rootViewController = UINavigationController(rootViewController: DesignSystemViewController())
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
