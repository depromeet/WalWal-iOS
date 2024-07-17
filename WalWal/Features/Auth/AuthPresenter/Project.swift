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
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    .Coordinator.Auth.Interface,
  ],
  implementDependencies: [
    .ThirdParty.Then,
    .ThirdParty.FlexLayout,
    .ThirdParty.PinLayout,
    .ThirdParty.RxCocoa,
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    
    .DependencyFactory.Interface,
    .Coordinator.Auth.Interface,
    .Feature.Auth.Domain.Interface,
    
    .DesignSystem,
    .ResourceKit
  ],
  demoAppDependencies: [
    .DependencyFactory.Interface,
    .DependencyFactory.Implement,
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
