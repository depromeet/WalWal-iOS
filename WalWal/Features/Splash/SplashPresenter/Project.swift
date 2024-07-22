//
//  SplashPresenterProject.swift
//
//  Splash
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "SplashPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
//    .Coordinator.App.Interface,
    .Feature.Splash.Domain.Interface
  ],
  implementDependencies: [
    .DesignSystem,
  ],
  demoAppDependencies: [
    .DependencyFactory.Implement
  ]
)
