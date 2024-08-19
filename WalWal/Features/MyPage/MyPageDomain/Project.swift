
//
//  MyPageDomainProject.swift
//
//  MyPage
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MyPageDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.MyPage.Data.Interface,
    .GlobalState,
    
    .ThirdParty.KakaoSDKUser
  ],
  implementDependencies: [
    .DependencyFactory.MyPage.Interface,
  ]
)


