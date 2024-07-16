//
//  AuthCoordinatorProject.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "AuthCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Base.Interface,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ],
  implementDependencies: [
    .Coordinator.Base.Interface,
    .DependencyFactory.Interface,
    
    .ThirdParty.RxSwift,
    .ThirdParty.RxCocoa
  ]
)
