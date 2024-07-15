//
//  SampleAuthCoordinatorProject.swift
//
//  SampleAuth
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SampleAuthCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Utility,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ],
  implementDependencies: [
    .Utility,
    .DependencyFactory.Interface,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ]
)


