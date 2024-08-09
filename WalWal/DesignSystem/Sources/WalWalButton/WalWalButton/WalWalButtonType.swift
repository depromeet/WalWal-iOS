//
//  WalWalButtonType.swift
//  DesignSystem
//
//  Created by 조용인 on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit
import ResourceKit

public enum WalWalButtonType {
  
  private typealias Colors = ResourceKitAsset.Colors
  
  case inactive
  case disabled
  case dark
  
  var configuration: WalWalButton.Configuration {
    switch self {
    case .inactive:
      return .init(
        backgroundColor: Colors.walwalOrange.color,
        isEnabled: true
      )
    case .disabled:
      return .init(
        backgroundColor: Colors.gray300.color,
        isEnabled: false
      )
    case .dark:
      return .init(
        backgroundColor: Colors.black.color,
        isEnabled: true
      )
    }
  }
}
