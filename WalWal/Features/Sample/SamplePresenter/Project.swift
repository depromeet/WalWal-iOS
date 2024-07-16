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

let project = Project.invertedReactorKitTargetProject(
  name: "SamplePresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  viewDependencies: [
    
    .ThirdParty.Then,
    .ThirdParty.FlexLayout,
    .ThirdParty.PinLayout,
    .ThirdParty.RxCocoa,
    .ThirdParty.RxSwift,
    .ThirdParty.ReactorKit,
    
    .DesignSystem,
    .ResourceKit,
    
    .Feature.Sample.Presenter.Reactor
  ],
  reactorDependencies: [
    .ThirdParty.ReactorKit,
    .ThirdParty.RxSwift,
    
    .DependencyFactory.Interface,
    
    .Feature.Sample.Domain.Interface
  ]
)

