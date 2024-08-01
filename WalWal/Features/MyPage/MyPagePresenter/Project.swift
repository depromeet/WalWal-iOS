//
//  MyPagePresenterProject.swift
//
//  MyPage
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedPresenterWithDemoApp(
  name: "MyPagePresenter",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .ThirdParty.ReactorKit,
    
    .Feature.MyPage.Domain.Interface,
  ],
  implementDependencies: [
    .DependencyFactory.MyPage.Interface,
    .DesignSystem
  ],
  demoAppDependencies: [
    .DependencyFactory.MyPage.Implement
  ]
)
