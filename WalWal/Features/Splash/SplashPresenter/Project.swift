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
    
    .Feature.Splash.Domain.Interface,
    .Feature.FCM.Domain.Interface,
    
    .Coordinator.App.Interface,
  ],
  implementDependencies: [
    .DependencyFactory.Splash.Interface,
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.Splash.Implement
  ]
)
