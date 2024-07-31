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
    .Coordinator.WalWalTabBar.Interface,
    .DependencyFactory.Mission.Interface,
    /// .DependencyFactory.Feed.Interface,
    /// .DependencyFactory.Notification.Interface,
    /// .DependencyFactory.MyPage.Interface,
  ],
  implementDependencies: [
    .Coordinator.WalWalTabBar.Implement
  ]
)
