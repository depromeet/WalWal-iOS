
//
//  OnboardingDomainProject.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "OnboardingDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Onboarding.Data.Interface,
    .Feature.Auth.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Onboarding.Interface
  ]
)


