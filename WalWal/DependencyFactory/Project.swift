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
    .Coordinator.Auth.Interface,
    
    .Feature.Splash.Data.Interface,
    .Feature.Splash.Domain.Interface,
    .Feature.Splash.Presenter.Interface,
    
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Domain.Interface,
    .Feature.Sample.Presenter.Interface,
    
    .Feature.Auth.Data.Interface,
    .Feature.Auth.Domain.Interface,
    .Feature.Auth.Presenter.Interface,
  ],
  implementDependencies: [
    .WalWalNetwork.Interface,
    .WalWalNetwork.Implement,
    
      .Coordinator.App.Interface,
    .Coordinator.App.Implement,
    .Coordinator.SampleApp.Interface,
    .Coordinator.SampleApp.Implement,
    .Coordinator.SampleAuth.Interface,
    .Coordinator.SampleAuth.Implement,
    .Coordinator.SampleHome.Interface,
    .Coordinator.SampleHome.Implement,
    .Coordinator.Auth.Interface,
    .Coordinator.Auth.Implement,
    
      .Feature.Splash.Data.Implement,
    .Feature.Splash.Data.Interface,
    .Feature.Splash.Domain.Interface,
    .Feature.Splash.Domain.Implement,
    .Feature.Splash.Presenter.Interface,
    .Feature.Splash.Presenter.Implement,
    
      .Feature.Sample.Data.Implement,
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Domain.Interface,
    .Feature.Sample.Domain.Implement,
    .Feature.Sample.Presenter.Interface,
    .Feature.Sample.Presenter.Implement,
    
      .Feature.Auth.Data.Interface,
    .Feature.Auth.Data.Implement,
    .Feature.Auth.Domain.Interface,
    .Feature.Auth.Domain.Implement,
    .Feature.Auth.Presenter.Interface,
    .Feature.Auth.Presenter.Implement,
  ]
)
