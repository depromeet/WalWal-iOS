//
//  SamplePresenterProject.swift
//
//  Sample
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "SamplePresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.Sample.Domain.Interface
  ],
  implementDependencies: [
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.Implement
  ]
)


