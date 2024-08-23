//
//  FeedPresenterProject.swift
//
//  Feed
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "FeedPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Feed.Domain.Interface,
    
    .Coordinator.Feed.Interface,
    .DesignSystem,
  ],
  implementDependencies: [
    
    .DependencyFactory.Feed.Interface,
  ],
  demoAppDependencies: [
    .DependencyFactory.Feed.Implement
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
