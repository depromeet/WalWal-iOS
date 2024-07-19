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
    .Coordinator.App.Interface,
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
    
    .Coordinator.App.Implement,
    .Coordinator.SampleApp.Implement,
    .Coordinator.SampleAuth.Implement,
    .Coordinator.SampleHome.Implement,
    
    .Feature.Splash.Data.Implement,
    .Feature.Splash.Domain.Implement,
    .Feature.Splash.Presenter.Implement,
    
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Domain.Implement,
    .Feature.Sample.Presenter.Implement
  ]
)
