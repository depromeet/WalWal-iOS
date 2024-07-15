//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "DependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Domain.Interface,
    /*
     // MARK: - 새로 생기는 Features의 Interface의 의존성만 가져오면 됩니다.
     /// Ex. Auth가 현재 존재하는 Feature라면,
     .Feature.Auth.Data.Interface,
     .Feature.Auth.Domain.Interface
     */
  ],
  implementDependencies: [
    .Feature.Sample.Data.Implement,
    .Feature.Sample.Data.Interface,
    .Feature.Sample.Domain.Interface,
    .Feature.Sample.Domain.Implement,
    /*
     // MARK: - 새로 생기는 Features의 Interface와 Implement를 모두 의존성으로 가져와야 합니다.
     /// Ex. Auth가 현재 존재하는 Feature라면,
     .WalWalNetwork.Interface,
     .WalWalNetwork.Implement,
     
     .Feature.Auth.Data.Interface,
     .Feature.Auth.Data.Implement,
     .Feature.Auth.Domain.Interface,
     .Feature.Auth.Domain.Implement
     */
  ]
)
