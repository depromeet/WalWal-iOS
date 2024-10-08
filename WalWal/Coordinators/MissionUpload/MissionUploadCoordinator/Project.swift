//
//  MissionUploadCoordinatorProject.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionUploadCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Base.Interface,
    .DependencyFactory.Records.Interface,
    .DesignSystem
  ],
  implementDependencies: [
    .DependencyFactory.MissionUpload.Interface
  ]
)
