//
//  AuthPresenterProject.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "AuthPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Auth.Domain.Interface
  ],
  implementDependencies: [
    .DependencyFactory.Auth.Interface,
    .DesignSystem,
    .Utility
  ],
  demoAppDependencies: [
    .DependencyFactory.Auth.Implement
  ],
  infoPlist: .extendingDefault(
    with:
      [
        "CFBundleDevelopmentRegion": "ko_KR",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1.0.0",
        "UILaunchStoryboardName": "LaunchScreen",
        "NSAppTransportSecurity" : [
          "NSAllowsArbitraryLoads": true
        ]
      ]
  )
)
