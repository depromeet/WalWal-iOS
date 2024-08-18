
//
//  MissionDomainProject.swift
//
//  Mission
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Mission.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Mission.Interface
  ]
)


