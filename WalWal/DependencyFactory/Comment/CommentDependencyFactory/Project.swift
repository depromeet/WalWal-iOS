//
//  CommentDependencyFactoryProject.swift
//
//  Comment
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "CommentDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Comment.Presenter.Interface
  ],
  implementDependencies: [
    .Feature.Comment.Data.Implement,
    .Feature.Comment.Domain.Implement,
    .Feature.Comment.Presenter.Implement
  ]
)
