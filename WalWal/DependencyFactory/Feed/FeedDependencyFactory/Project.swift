//
//  FeedDependencyFactoryProject.swift
//
//  Feed
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "FeedDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    ///.Coordinator.Feed.Interface,
    
    ///.Feature.Feed.Data.Interface,
    ///.Feature.Feed.Domain.Interface,
    .Feature.Feed.Presenter.Interface
  ],
  implementDependencies: [
    .Coordinator.Feed.Implement,
    
    .Feature.Feed.Data.Implement,
    .Feature.Feed.Domain.Implement,
    .Feature.Feed.Presenter.Implement
  ]
)
