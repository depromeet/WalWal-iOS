//
//  SplashDependencyFactoryProject.swift
//
//  Splash
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SplashDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.App.Interface,
    .DependencyFactory.Auth.Interface,
    .DependencyFactory.WalWalTabBar.Interface,
    .DependencyFactory.Onboarding.Interface,
    .DependencyFactory.Records.Interface,
    .DependencyFactory.FCM.Interface,
    .DependencyFactory.MyPage.Interface,
    .DependencyFactory.Members.Interface,
    
    .Feature.Splash.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.App.Implement,
    
    .Feature.Splash.Data.Implement,
    .Feature.Splash.Domain.Implement,
    .Feature.Splash.Presenter.Implement
  ]
)
