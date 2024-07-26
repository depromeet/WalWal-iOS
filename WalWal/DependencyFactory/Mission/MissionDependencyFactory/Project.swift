//
//  MissionDependencyFactoryProject.swift
//
//  Mission
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Mission.Interface,
    
    .Feature.Mission.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.Mission.Implement,
    
    .Feature.Mission.Data.Implement,
    .Feature.Mission.Domain.Implement,
    .Feature.Mission.Presenter.Implement
  ]
)
