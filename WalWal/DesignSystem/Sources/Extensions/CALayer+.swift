//
//  CALayer+.swift
//  DesignSystem
//
//  Created by 이지희 on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

extension CALayer {
  func addBorder(
    _ arrEdge: [UIRectEdge],
    color: UIColor,
    width: CGFloat
  ) {
    for edge in arrEdge {
      let border = CALayer()
      switch edge {
      case UIRectEdge.top:
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
        break
      case UIRectEdge.bottom:
        border.frame = CGRect.init(x: 0, y: frame.height, width: frame.width, height: width )
        break
      case UIRectEdge.left:
        border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
        break
      case UIRectEdge.right:
        border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
        break
      default:
        break
      }
      border.backgroundColor = color.cgColor
      self.addSublayer(border)
    }
  }
}
