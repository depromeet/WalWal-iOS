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
    
    ///.DependencyFactory.Auth.Interface,
    .DependencyFactory.Onboarding.Interface,
    
    .DependencyFactory.WalWalTabBar.Interface,
    
    ///.DependencyFactory.Mission.Interface,
    ///.DependencyFactory.MissionUpload.Interface,
    
    ///.DependencyFactory.Feed.Interface,
    
    ///.DependencyFactory.FCM.Interface,
    
    ///.DependencyFactory.MyPage.Interface,
    ///.DependencyFactory.Records.Interface,
    
    ///.DependencyFactory.Image.Interface,
    
    ///.Coordinator.App.Interface,
    
    .Feature.Splash.Presenter.Interface,
    ///.Feature.Splash.Domain.Interface,
    ///.Feature.Splash.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.App.Implement,
    
    .Feature.Splash.Data.Implement,
    .Feature.Splash.Domain.Implement,
    .Feature.Splash.Presenter.Implement
  ]
)
