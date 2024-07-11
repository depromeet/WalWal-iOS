
//
//  AuthDomainProject.swift
//
//  Auth
//
//  Created by 조용인
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
  ],
  implementDependencies: [
    .ThirdParty.RxSwift,
    
    .Feature.Auth.Data.Interface
  ]
)


