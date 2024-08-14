//
//  FCMDependencyFactoryProject.swift
//
//  FCM
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "FCMDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.FCM.Data.Interface,
    .Feature.FCM.Domain.Interface
  ],
  implementDependencies: [
    .Feature.FCM.Data.Implement,
    .Feature.FCM.Domain.Implement
  ]
)
