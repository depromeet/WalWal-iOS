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
  case normal
  case dark
  case orange
  
  var tintColor: UIColor {
    switch self {
    case .normal:
      return ResourceKitAsset.Colors.black.color
    case .dark, .orange:
      return ResourceKitAsset.Colors.white.color
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .normal:
      return .clear
    case .dark:
      return ResourceKitAsset.Colors.black.color
    case .orange:
      return ResourceKitAsset.Colors.walwalOrange.color
    }
  }
}

