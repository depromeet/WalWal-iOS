//
//  UIDevice+.swift
//  DesignSystem
//
//  Created by 이지희 on 11/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension UIDevice {
  /// SE 사이즈인지 검사
  static var isSESizeDevice: Bool {
    return UIScreen.main.bounds.height <= 667
  }
}
