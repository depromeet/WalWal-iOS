//
//  OnboardingDependencyFactoryProject.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "OnboardingDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    /// .DependencyFactory.FCM.Interface,
    .DependencyFactory.Auth.Interface,
    .DependencyFactory.Image.Interface,
    
    ///.Coordinator.Onboarding.Interface,
    
    ///.Feature.Onboarding.Data.Interface,
    ///.Feature.Onboarding.Domain.Interface,
    .Feature.Onboarding.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.Onboarding.Implement,
    
    .Feature.Onboarding.Data.Implement,
    .Feature.Onboarding.Domain.Implement,
    .Feature.Onboarding.Presenter.Implement
  ]
)
