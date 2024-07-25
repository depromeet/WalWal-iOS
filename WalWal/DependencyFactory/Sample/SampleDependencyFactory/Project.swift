//
//  SampleDependencyFactoryProject.swift
//
//  Sample
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SampleDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.SampleApp.Interface,
    .Coordinator.SampleAuth.Interface,
    .Coordinator.SampleHome.Interface,
    
    .Feature.Sample.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.SampleApp.Implement,
    .Coordinator.SampleAuth.Implement,
    .Coordinator.SampleHome.Implement,
    
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Domain.Implement,
    .Feature.Sample.Presenter.Implement
  ]
)
