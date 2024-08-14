//
//  RecordsDependencyFactoryProject.swift
//
//  Records
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "RecordsDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Records.Interface,
    
    .Feature.Records.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.Records.Implement
    
    .Feature.Records.Data.Implement,
    .Feature.Records.Domain.Implement,
    .Feature.Records.Presenter.Implement
  ]
)
