//
//  NavigationBarItemType.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

public enum NavigationBarItemType {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  case none
  case close
  case back
  case setting
  
  var icon: UIImage? {
    switch self {
    case .none:
      return nil
    case .close:
      return Images.closeL.image
    case .back:
      return Images.backL.image
    case .setting:
      return Images.settingL.image
    }
  }
}
