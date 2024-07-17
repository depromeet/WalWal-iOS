
//
//  AuthDomainProject.swift
//
//  Auth
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "AuthDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.RxSwift,
    .Feature.Auth.Data.Interface
  ],
  implementDependencies: [
    .ThirdParty.RxSwift,
    
    .Feature.Auth.Data.Interface
  ]
)


