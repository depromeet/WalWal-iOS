//
//  CommentDataProject.swift
//
//  Comment
//
//  Created by 조용인
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "CommentData",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .WalWalNetwork
  ],
  implementDependencies: [
    .DependencyFactory.Comment.Interface
  ]
)


