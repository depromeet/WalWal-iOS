//
//  MembersDependencyFactoryProject.swift
//
//  Members
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MembersDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Members.Domain.Interface,
    .Feature.Members.Data.Interface
  ],
  implementDependencies: [
    .Feature.Members.Data.Implement,
    .Feature.Members.Domain.Implement
  ]
)
