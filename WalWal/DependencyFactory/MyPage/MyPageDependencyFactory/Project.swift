//
//  MyPageDependencyFactoryProject.swift
//
//  MyPage
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MyPageDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.MyPage.Interface,
    .DependencyFactory.FCM.Interface,
    .DependencyFactory.Auth.Interface,
    .DependencyFactory.Members.Interface,
    
    .Feature.MyPage.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.MyPage.Implement,
    
    .Feature.MyPage.Data.Implement,
    .Feature.MyPage.Domain.Implement,
    .Feature.MyPage.Presenter.Implement
  ]
)
