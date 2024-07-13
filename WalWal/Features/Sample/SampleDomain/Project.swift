
//
//  SampleDomainProject.swift
//
//  Sample
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SampleDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.RxSwift,
  ],
  implementDependencies: [
    .ThirdParty.RxSwift,
    
    .Feature.Sample.Data.Interface
  ]
)


