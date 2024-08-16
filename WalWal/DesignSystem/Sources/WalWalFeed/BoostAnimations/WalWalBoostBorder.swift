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
  
  private var borderLayers: [CAShapeLayer] = []
  private weak var containerView: UIView?
  private let cornerRadius: CGFloat = 20
  
  func addBorderLayer(to view: UIView) {
    containerView = view
    borderLayers.forEach { $0.removeFromSuperlayer() }
    borderLayers.removeAll()
  }
  
  func startBorderAnimation(borderColor: UIColor, isRainbow: Bool = false) {
    guard let containerView = containerView else { return }
    
    let newLayer = CAShapeLayer()
    let path = createDashedBorderPath(in: containerView.bounds)
    newLayer.path = path.cgPath
    newLayer.fillColor = UIColor.clear.cgColor
    newLayer.lineWidth = 5
    newLayer.strokeColor = borderColor.cgColor
    
    // 상단 중앙에서 시작하는 설정
    newLayer.strokeStart = 0.0
    newLayer.strokeEnd = 0.0
    
    containerView.layer.addSublayer(newLayer)
    borderLayers.append(newLayer)
    
    if isRainbow {
      startRainbowBorderAnimation(for: newLayer)
    } else {
      startDefaultBorderAnimation(for: newLayer)
    }
  }
  
  private func createDashedBorderPath(in rect: CGRect) -> UIBezierPath {
      let path = UIBezierPath()
      let midX = rect.midX
      let minY = rect.minY
      let maxX = rect.maxX
      let maxY = rect.maxY
      let minX = rect.minX
      
      // 상단 중앙에서 시작
      path.move(to: CGPoint(x: midX, y: minY))
      
      // 오른쪽 상단 모서리
    path.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))
    path.addArc(
      withCenter: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius),
      radius: cornerRadius,
      startAngle: 3 * .pi / 2,
      endAngle: 0,
      clockwise: true
    )
    
    // 오른쪽 하단 모서리
    path.addLine(to: CGPoint(x: maxX, y: maxY - cornerRadius))
    path.addArc(
      withCenter: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius),
      radius: cornerRadius,
      startAngle: 0,
      endAngle: .pi / 2,
      clockwise: true
    )
    
    // 왼쪽 하단 모서리
    path.addLine(to: CGPoint(x: minX + cornerRadius, y: maxY))
    path.addArc(
      withCenter: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius),
      radius: cornerRadius,
      startAngle: .pi / 2,
      endAngle: .pi,
      clockwise: true
    )
    
    // 왼쪽 상단 모서리
    path.addLine(to: CGPoint(x: minX, y: minY + cornerRadius))
    path.addArc(
      withCenter: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius),
      radius: cornerRadius,
      startAngle: .pi,
      endAngle: 3 * .pi / 2,
      clockwise: true
    )
      
      // 다시 시작점으로
      path.addLine(to: CGPoint(x: midX, y: minY))
      
      return path
    }
  
  func stopBorderAnimation() {
    borderLayers.forEach { layer in
      layer.removeAllAnimations()
      layer.removeFromSuperlayer()
    }
    borderLayers.removeAll()
  }
  
  private func startRainbowBorderAnimation(for layer: CAShapeLayer) {
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
    
    layer.add(rainbowAnimation, forKey: "rainbowBorderAnimation")
    
    let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeAnimation.fromValue = 0.0
    strokeAnimation.toValue = 1.0
    strokeAnimation.duration = 2.5
    strokeAnimation.fillMode = .forwards
    strokeAnimation.isRemovedOnCompletion = false
    
    layer.add(strokeAnimation, forKey: "strokeAnimation")
  }
  
  private func startDefaultBorderAnimation(for layer: CAShapeLayer) {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 2.5
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    
    layer.add(animation, forKey: "borderAnimation")
  }
}
