//
//  UIColor+.swift
//  DesignSystem
//
//  Created by 조용인 on 7/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

extension UIColor {
  
  /// UIColor를 hex값으로 초기화합니다.
  /// - Parameters:
  ///   - hex: hex값
  ///   - alpha: alpha값 (default -> 1.0)
  public convenience init(hex: UInt, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: CGFloat(alpha)
    )
  }
  
  /// hex Code String를 UIColor로 사용하기 위한 extension 함수입니다.
  /// 사용 예시
  ///  ``` swift
  ///  UIColor(hexCode:"FFDD77")
  ///  ```
  public convenience init(hexCode: String, alpha: CGFloat = 1.0) {
    var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }
  
  
}
