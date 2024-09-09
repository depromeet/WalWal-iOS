//
//  UIScrollView.swift
//  DesignSystem
//
//  Created by 이지희 on 8/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension UIScrollView {
  func isNearBottom(offset: CGFloat = 20.0) -> Bool {
    return (self.contentOffset.y + self.frame.height + offset) > self.contentSize.height
  }
}
