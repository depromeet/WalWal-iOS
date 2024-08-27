//
//  Adjusted+.swift
//  DesignSystem
//
//  Created by 이지희 on 8/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit


public extension Int {
  /// 기기대응 시, 비율에 맞게 간격, 크기를 조정하기 위한 extension 함수입니다.
  ///
  /// 사용 예시
  /// ``` swift
  /// $0.addItem(missionStartButton)
  ///  .marginTop(10.adjusted)
  /// ```
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

public extension Float {
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
