
//
//  FCMDomainProject.swift
//
//  FCM
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "FCMDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.FCM.Data.Interface
  ],
  implementDependencies: [
    .DependencyFactory.FCM.Interface
  ]
)


