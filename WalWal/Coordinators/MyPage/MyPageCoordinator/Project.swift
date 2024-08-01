//
//  MyPageCoordinatorProject.swift
//
//  MyPage
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MyPageCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Base.Interface
  ],
  implementDependencies: [
    .DependencyFactory.MyPage.Interface
  ]
)
