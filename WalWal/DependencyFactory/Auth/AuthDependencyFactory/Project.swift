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
    
    .Feature.Auth.Presenter.Interface,
  ],
  implementDependencies: [
    .Coordinator.Auth.Implement,
    
    .Feature.Auth.Data.Implement,
    .Feature.Auth.Domain.Implement,
    .Feature.Auth.Presenter.Implement,
    
    .Feature.FCM.Data.Implement,
    .Feature.FCM.Domain.Implement
    
  ]
)
