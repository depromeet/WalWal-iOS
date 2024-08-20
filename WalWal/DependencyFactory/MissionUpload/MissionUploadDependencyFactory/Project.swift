//
//  MissionUploadDependencyFactoryProject.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionUploadDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .DependencyFactory.Records.Interface,
    .DependencyFactory.Image.Interface,
    
    ///.Coordinator.MissionUpload.Interface,
    
    .Feature.MissionUpload.Presenter.Interface,
    ///.Feature.MissionUpload.Domain.Interface
  ],
  implementDependencies: [
    .Coordinator.MissionUpload.Implement,
    
    .Feature.MissionUpload.Presenter.Implement,
    .Feature.MissionUpload.Domain.Implement,
  ]
)
