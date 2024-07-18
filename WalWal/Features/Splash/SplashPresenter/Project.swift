//
//  SplashPresenterProject.swift
//
//  Splash
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "SplashPresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    
    .Coordinator.App.Interface
  ],
  implementDependencies: [
    .ThirdParty.Then,
    .ThirdParty.FlexLayout,
    .ThirdParty.PinLayout,
    .ThirdParty.RxCocoa,
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    
    .Coordinator.App.Interface,
    .Feature.Splash.Domain.Interface,
    
    .DesignSystem,
    .ResourceKit
  ],
  demoAppDependencies: [
    .DependencyFactory.Interface,
    .DependencyFactory.Implement,
  ]
)
