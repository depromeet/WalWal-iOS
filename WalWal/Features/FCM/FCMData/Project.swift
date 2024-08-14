//
//  FCMDataProject.swift
//
//  FCM
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "FCMData",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .WalWalNetwork
  ],
  implementDependencies: [
    .DependencyFactory.FCM.Interface
  ]
)


