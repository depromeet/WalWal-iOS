//
//  BoostAnimationType.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

/// Boost효과 케이스에 따른 변수들을 정리
public enum WalWalBurstString {
  case cute
  case cool
  case lovely
  
  var font: UIFont {
    switch self {
    case .cute: return ResourceKitFontFamily.LotteriaChab.Buster_Cute
    case .cool: return ResourceKitFontFamily.LotteriaChab.Buster_Cool
    case .lovely: return ResourceKitFontFamily.LotteriaChab.Buster_Lovely
    }
  }
  
  var normalText: String {
    switch self {
    case .cute: return "귀여워!"
    case .cool: return "멋져!"
    case .lovely: return "사랑스러워!"
    }
  }
  
  var goodText: String {
    switch self {
    case .cute: return "너무 귀여워!"
    case .cool: return "너무 멋져!"
    case .lovely: return "너무 사랑스러워!"
    }
  }
  
  var greatText: String {
    switch self {
    case .cute: return "너무너무 귀여워!"
    case .cool: return "너무너무 멋져!"
    case .lovely: return "너무너무 사랑스러워!"
    }
  }
}
