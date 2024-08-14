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
    .Coordinator.Onboarding.Interface,
    .DependencyFactory.FCM.Interface,
    
    .Feature.Onboarding.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.Onboarding.Implement,
    
    .Feature.Auth.Data.Implement,
    .Feature.Onboarding.Data.Implement,
    .Feature.Onboarding.Domain.Implement,
    .Feature.Onboarding.Presenter.Implement
  ]
)
