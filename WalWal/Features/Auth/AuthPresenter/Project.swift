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
    .ThirdParty.KakaoSDKAuth,
    .ThirdParty.KakaoSDKUser,
    
    .DependencyFactory.Auth.Interface,
    .DesignSystem,
    .Utility,
    .LocalStorage
  ],
  demoAppDependencies: [
    .DependencyFactory.Auth.Implement
  ]
)
