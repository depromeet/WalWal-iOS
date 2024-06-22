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
  name: "Network",
  platform: .iOS,
  interfaceDependencies: [
    .ThirdParty.Alamofire
  ],
  implementDependencies: [
    .ThirdParty.Alamofire
  ]
)
