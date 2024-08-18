//
//  MissionUploadPresenterProject.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "MissionUploadPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.MissionUpload.Domain.Interface,
  ],
  implementDependencies: [
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.MissionUpload.Implement
  ]
)
