
//
//  SplashDomainProject.swift
//
//  Splash
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "SplashDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.RxSwift,
  ],
  implementDependencies: [
    .ThirdParty.RxSwift,
    
    .Feature.Splash.Data.Interface
  ]
)


