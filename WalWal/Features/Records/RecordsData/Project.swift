//
//  RecordsDataProject.swift
//
//  Records
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "RecordsData",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .WalWalNetwork
  ],
  implementDependencies: []
)


