//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.framework(
  name: "ResourceKit",
  platform: .iOS,
  infoPlist: [
    "CFBundleDevelopmentRegion": "ko_KR",
    "UIAppFonts": [
      "Item 0": "chab.otf"
    ]
  ],
  iOSTargetVersion: "15.0.0",
  dependencies: []
)
