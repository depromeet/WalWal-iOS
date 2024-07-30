//
//  MissionDataProject.swift
//
//  Mission
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MissionData",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .WalWalNetwork
  ],
  implementDependencies: [
    .DependencyFactory.Mission.Interface
  ]
)


