
//
//  RecordsDomainProject.swift
//
//  Records
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "RecordsDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Records.Data.Interface
  ],
  implementDependencies: []
)


