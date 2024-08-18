//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let organizationName = "olderStoneBed.io"

let project = Project(
  name: "Utility",
  organizationName: organizationName,
  settings: .settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
  ]),
  targets: [
    Target(
      name: "Utility",
      platform: .iOS,
      product: .framework,
      bundleId: "\(organizationName).Utility",
      deploymentTarget: .iOS(
        targetVersion: "15.0.0",
        devices: [.iphone]
      ),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .ThirdParty.RxCocoa,
        .ThirdParty.Kingfisher
      ]
    ),
  ]
)
