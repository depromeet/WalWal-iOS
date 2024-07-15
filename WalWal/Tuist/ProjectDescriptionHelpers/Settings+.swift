//
//  Settings+.swift
//  Config
//
//  Created by 조용인 on 6/22/24.
//

import ProjectDescription

extension Settings {
  static var flexLayoutSetting: Settings {
    return .settings(
      base: [
        "GCC_PREPROCESSOR_DEFINITIONS[arch=*]": "FLEXLAYOUT_SWIFT_PACKAGE=1",
      ],
      configurations: [.debug(name: .debug), .release(name: .release)]
    )
  }
}
