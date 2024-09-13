//
//  NavigationBarColorSet.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ResourceKit

public enum NavigationBarColorSet {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  case normal
  case dark
  case orange
  case custom(tintColor: UIColor, backgroundColor: UIColor)
  
  var tintColor: UIColor {
    switch self {
    case .normal:
      return Colors.black.color
    case .dark, .orange:
      return Colors.white.color
    case let .custom(tintColor, backgroundColor):
      return tintColor
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .normal:
      return .clear
    case .dark:
      return Colors.black.color
    case .orange:
      return Colors.walwalOrange.color
    case let .custom(tintColor, backgroundColor):
      return backgroundColor
    }
  }
}

