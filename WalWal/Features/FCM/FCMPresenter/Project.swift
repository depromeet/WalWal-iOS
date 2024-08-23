//
//  FCMPresenterProject.swift
//
//  FCM
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "FCMPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.FCM.Domain.Interface,
    
    .Coordinator.FCM.Interface
  ],
  implementDependencies: [
    .DependencyFactory.FCM.Interface,
    .Utility,
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.FCM.Implement
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
