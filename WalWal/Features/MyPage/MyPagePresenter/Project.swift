//
//  MyPagePresenterProject.swift
//
//  MyPage
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "MyPagePresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    .Coordinator.MyPage.Interface,
    
    .Feature.MyPage.Domain.Interface,
    .Feature.Auth.Domain.Interface,
    .Feature.Records.Domain.Interface,
    .DesignSystem
  ],
  implementDependencies: [
    .DependencyFactory.MyPage.Interface,
    
  ],
  demoAppDependencies: [
    .DependencyFactory.MyPage.Implement
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
