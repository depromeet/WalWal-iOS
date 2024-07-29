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
  case none
  case close
  case back
  case setting
  
  var icon: UIImage? {
    switch self {
    case .none:
      return nil
    case .close:
      return ResourceKitAsset.Assets._24x24Close.image
    case .back:
      return ResourceKitAsset.Assets._20x20ChevronLeft.image
    case .setting:
      return ResourceKitAsset.Assets._24x24Settings.image
    }
  }
}
