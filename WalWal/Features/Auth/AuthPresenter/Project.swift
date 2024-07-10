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

let project = Project.invertedReactorKitTargetProject(
  name: "Auth",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  viewDependencies: [
    .ThirdParty.ReactorKit,
    .ThirdParty.FlexLayout,
    .ThirdParty.PinLayout,
    .ThirdParty.RxCocoa,
    .ThirdParty.RxSwift,
    
      .DesignSystem,
    .ResourceKit
  ],
  reactorDependencies: [
    .ThirdParty.ReactorKit,
    .ThirdParty.RxSwift,
    
      .Feature.Auth.Domain.Interface
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


