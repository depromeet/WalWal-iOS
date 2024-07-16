//
//  CoordinatorTypeCoordinatorProject.swift
//
//  CoordinatorType
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "CoordinatorTypeCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Utility,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ],
  implementDependencies: [
    .DependencyFactory.Interface,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ]
)
