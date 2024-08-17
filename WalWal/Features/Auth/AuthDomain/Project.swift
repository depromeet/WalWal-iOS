
//
//  AuthDomainProject.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "AuthDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Auth.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Auth.Interface
  ]
)


