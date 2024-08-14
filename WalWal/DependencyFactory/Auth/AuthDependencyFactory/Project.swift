//
//  AuthDependencyFactoryProject.swift
//
//  Auth
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "AuthDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Auth.Interface,
    .DependencyFactory.FCM.Interface,
    
    .Feature.Auth.Presenter.Interface,
    .Feature.FCM.Domain.Interface
  ],
  implementDependencies: [
    .Coordinator.Auth.Implement,
    
    .Feature.Auth.Data.Implement,
    .Feature.Auth.Domain.Implement,
    .Feature.Auth.Presenter.Implement,
    
  ]
)
