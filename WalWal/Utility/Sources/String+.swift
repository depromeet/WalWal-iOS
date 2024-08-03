//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public extension String {
  func isValidNickName() -> Bool {
    let nicknameRegex = "^[가-힣A-Za-z0-9]+$"
    return NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
          .evaluate(with: self)
  }
}
