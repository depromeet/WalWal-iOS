//
//  RecordsPresenterProject.swift
//
//  Records
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "RecordsPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Records.Domain.Interface,
  ],
  implementDependencies: [
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.Implement
  ]
)
