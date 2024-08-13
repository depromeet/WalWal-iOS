//
//  WalWalBoostBorder.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class WalWalBoostBorder {
  
  private typealias Colors = ResourceKitAsset.Colors
  
  private var borderLayer: CAShapeLayer?
  
  func addBorderLayer(to view: UIView) {
    borderLayer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
    borderLayer?.path = path.cgPath
    borderLayer?.fillColor = UIColor.clear.cgColor
    borderLayer?.lineWidth = 5
    borderLayer?.strokeEnd = 0
    view.layer.addSublayer(borderLayer!)
  }
  
  func startBorderAnimation(borderColor: UIColor, isRainbow: Bool = false) {
    if isRainbow {
      startRainbowBorderAnimation()
    } else {
      startDefaultBorderAnimation(borderColor: borderColor)
    }
  }
  
  func stopBorderAnimation() {
    borderLayer?.removeAllAnimations()
    borderLayer?.removeFromSuperlayer()
    borderLayer = nil
  }
  
  private func startRainbowBorderAnimation() {
    let colors: [CGColor] = [
      Colors.pink.color.cgColor,
      Colors.walwalOrange.color.cgColor,
      Colors.yellow.color.cgColor,
      Colors.green.color.cgColor,
      Colors.skyblue.color.cgColor,
      Colors.blue.color.cgColor,
      Colors.purple.color.cgColor,
      Colors.pink.color.cgColor
    ]
    
    let rainbowAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
    rainbowAnimation.values = colors
    rainbowAnimation.keyTimes = [0, 0.14, 0.28, 0.43, 0.58, 0.72, 0.87, 1.0]
    rainbowAnimation.duration = 5.0
    rainbowAnimation.repeatCount = .infinity
    
    borderLayer?.add(rainbowAnimation, forKey: "rainbowBorderAnimation")
  }
  
  private func startDefaultBorderAnimation(borderColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 2.5
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    
    borderLayer?.strokeColor = borderColor.cgColor
    borderLayer?.add(animation, forKey: "borderAnimation")
  }
}
