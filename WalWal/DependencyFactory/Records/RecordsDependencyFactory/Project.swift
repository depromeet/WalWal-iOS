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
    ///.Feature.Records.Data.Interface,
    .Feature.Records.Domain.Interface
  ],
  implementDependencies: [
    .Feature.Records.Data.Implement,
    .Feature.Records.Domain.Implement
  ]
)
