//
//  Settings+.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

extension Settings {
  public static var flexLayoutSetting: Settings {
    return .settings(base: ["GCC_PREPROCESSOR_DEFINITIONS": "FLEXLAYOUT_SWIFT_PACKAGE=1"],
                     configurations: [
                      .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
                      .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig"))
                     ])
  }
}

