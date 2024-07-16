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
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
  ],
  implementDependencies: [
    .ThirdParty.Then,
    .ThirdParty.FlexLayout,
    .ThirdParty.PinLayout,
    .ThirdParty.RxCocoa,
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    
    .DependencyFactory.Interface,
    
    .Feature.Sample.Domain.Interface,
    
    .DesignSystem,
    .ResourceKit
  ]
)


