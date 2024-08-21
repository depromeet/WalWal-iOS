//
//  MissionPresenterProject.swift
//
//  Mission
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "MissionPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Mission.Domain.Interface,
    
    .Coordinator.Mission.Interface
  ],
  implementDependencies: [
    .DependencyFactory.Mission.Interface,
    .Utility,
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.Mission.Implement
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
