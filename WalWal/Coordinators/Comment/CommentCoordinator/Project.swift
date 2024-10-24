//
//  CommentCoordinatorProject.swift
//
//  Comment
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "CommentCoordinator",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Coordinator.Base.Interface
  ],
  implementDependencies: [
    .DependencyFactory.Comment.Interface
  ]
)
