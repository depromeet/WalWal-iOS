
//
//  ImageDomainProject.swift
//
//  Image
//
//  Created by 이지희
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.invertedDualTargetProject(
  name: "ImageDomain",
  platform: .iOS,
  iOSTargetVersion: "15.0.0",
  interfaceDependencies: [
    .Feature.Image.Data.Interface
  ],
  implementDependencies: [
    .DependencyFactory.Image.Interface
  ]
)


