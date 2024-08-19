
//
//  MissionUploadDomainProject.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionUploadDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [],
  implementDependencies: [
    .DependencyFactory.MissionUpload.Interface
  ]
)


