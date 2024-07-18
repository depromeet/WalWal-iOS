//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "DependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.SampleApp.Interface,
    .Coordinator.SampleAuth.Interface,
    .Coordinator.SampleHome.Interface,
    
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Domain.Interface,
    .Feature.Sample.Presenter.Interface
  ],
  implementDependencies: [
    .WalWalNetwork.Interface,
    .WalWalNetwork.Implement,
    
    .Coordinator.SampleApp.Interface,
    .Coordinator.SampleApp.Implement,
    .Coordinator.SampleAuth.Interface,
    .Coordinator.SampleAuth.Implement,
    .Coordinator.SampleHome.Interface,
    .Coordinator.SampleHome.Implement,
    
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Domain.Interface,
    .Feature.Sample.Domain.Implement,
    .Feature.Sample.Presenter.Interface,
    .Feature.Sample.Presenter.Implement
  ]
)
