//
//  OnboardingPresenterProject.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "OnboardingPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Onboarding.Domain.Interface,
  ],
  implementDependencies: [
    .DependencyFactory.Onboarding.Interface,
    .DesignSystem,
    .Utility
  ],
  demoAppDependencies: [
    .DependencyFactory.Onboarding.Implement
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
