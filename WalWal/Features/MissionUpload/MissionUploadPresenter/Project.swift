//
//  MissionUploadPresenterProject.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "MissionUploadPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    .Utility,
    
    .Feature.MissionUpload.Domain.Interface,
  ],
  implementDependencies: [
    .DependencyFactory.MissionUpload.Interface,
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.MissionUpload.Implement
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
