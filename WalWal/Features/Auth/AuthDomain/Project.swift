
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
    .ThirdParty.KakaoSDKAuth,
    .ThirdParty.KakaoSDKUser,
    
    .Feature.Auth.Data.Interface
  ],
  implementDependencies: [
    .DependencyFactory.Auth.Interface
  ]
)


