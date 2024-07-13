//
//  SampleDataProject.swift
//
//  Sample
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SampleData",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.RxSwift
  ],
  implementDependencies: [
    .ThirdParty.RxSwift,
    .WalWalNetwork.Interface
  ]
)


