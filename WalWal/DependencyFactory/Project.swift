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
    .Coordinator.Onboarding.Interface,

    .Feature.Splash.Presenter.Interface,
    .Feature.Sample.Presenter.Interface,
    .Feature.Auth.Presenter.Interface,
    .Feature.Onboarding.Presenter.Interface
  ],
  implementDependencies: [
    .WalWalNetwork.Implement,
    
    .Coordinator.App.Implement,
    .Coordinator.SampleApp.Implement,
    .Coordinator.SampleAuth.Implement,
    .Coordinator.SampleHome.Implement,
    .Coordinator.Auth.Implement,
    .Coordinator.Onboarding.Interface,
    .Coordinator.Onboarding.Implement,
    
    .Feature.Splash.Data.Implement,
    .Feature.Splash.Domain.Implement,
    .Feature.Splash.Presenter.Implement,
    
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Domain.Implement,
    .Feature.Sample.Presenter.Implement,
    
    .Feature.Auth.Data.Implement,
    .Feature.Auth.Domain.Implement,
    .Feature.Auth.Presenter.Implement,

    .Feature.Onboarding.Data.Implement,
    .Feature.Onboarding.Domain.Implement,
    .Feature.Onboarding.Presenter.Implement
  ]
)
