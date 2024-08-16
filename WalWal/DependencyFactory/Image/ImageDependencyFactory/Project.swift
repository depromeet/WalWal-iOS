//
//  ImageDependencyFactoryProject.swift
//
//  Image
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "ImageDependencyFactory",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Image.Domain.Interface,
    .Feature.Image.Data.Interface
  ],
  implementDependencies: [
    .Feature.Image.Data.Implement,
    .Feature.Image.Domain.Implement,
  ]
)
