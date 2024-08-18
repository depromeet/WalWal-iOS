
//
//  FeedDomainProject.swift
//
//  Feed
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "FeedDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Feed.Data.Interface,
    .GlobalState
  ],
  implementDependencies: [
    .DependencyFactory.Feed.Interface
  ]
)


