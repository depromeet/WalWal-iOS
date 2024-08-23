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
    ///.Feature.FCM.Data.Interface,
    .Feature.FCM.Domain.Interface,
    .Feature.FCM.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.FCM.Implement,
    
    .Feature.FCM.Data.Implement,
    .Feature.FCM.Domain.Implement,
    .Feature.FCM.Presenter.Implement
  ]
)
