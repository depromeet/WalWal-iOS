
//
//  CommentDomainProject.swift
//
//  Comment
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "CommentDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Comment.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Comment.Interface
  ]
)


