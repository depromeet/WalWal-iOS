//
//  WalWalTabBarDependencyFactoryProject.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "WalWalTabBarDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .DependencyFactory.Mission.Interface,
    .DependencyFactory.Feed.Interface,
    .DependencyFactory.MyPage.Interface,
    ///.DependencyFactory.FCM.Interface,
    
    .Coordinator.WalWalTabBar.Interface,
  ],
  implementDependencies: [
    .Coordinator.WalWalTabBar.Implement
  ]
)
