//
//  MissionCoordinatorProject.swift
//
//  Mission
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Base.Interface,
  ],
  implementDependencies: [
    .DependencyFactory.Mission.Interface
  ]
)