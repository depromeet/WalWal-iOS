//
//  Double+.swift
//  Utility
//
//  Created by 이지희 on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension Double {
  var adjusted: CGFloat {
    let ratio: CGFloat = UIScreen.main.bounds.width / 375
    let ratioH: CGFloat = UIScreen.main.bounds.height / 812
    return ratio <= ratioH ? CGFloat(self) * ratio : CGFloat(self) * ratioH
  }
  
  var adjustedWidth: CGFloat {
    let ratio: CGFloat = UIScreen.main.bounds.width / 375
    return CGFloat(self) * ratio
  }
  
  var adjustedHeight: CGFloat {
    let ratio: CGFloat = UIScreen.main.bounds.height / 812
    return CGFloat(self) * ratio
  }
}
