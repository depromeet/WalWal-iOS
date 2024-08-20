
//
//  MembersDomainProject.swift
//
//  Members
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "MembersDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Members.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Members.Interface
  ]
)


