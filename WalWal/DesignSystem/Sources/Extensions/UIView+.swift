//
//  UIView+.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension Reactive where Base: UIView {
  
  /// UIView를 Tap했을 때,  `ControlEvent<Void>` 를 방출하는 property 입니다.
  /// - Returns: `ControlEvent<Void>`
  public var tapped: ControlEvent<Void> {
    let event: Observable<Void> = base.rx.tapGesture()
      .when(.recognized)
      .throttle(
        .milliseconds(1000),
        latest: false,
        scheduler: MainScheduler.instance
      )
      .map{ _ in }
    return ControlEvent(events: event)
  }
}

public extension UIView {
  
  // MARK: Easily get frames parameters
  
  /// 현재 뷰의 너비 반환
  var width: CGFloat {
    return self.frame.size.width
  }
  
  /// 현재 뷰의 높이 반환
  var height: CGFloat {
    return self.frame.size.height
  }
  
  /// 현재 뷰의 x posiotion
  var x: CGFloat {
    return self.frame.origin.x
  }
  
  /// 현재 뷰의 y position
  var y: CGFloat {
    return self.frame.origin.y
  }
  
  // MARK: - Easily Set Attributes
  
  /// UIView의 모서리를 둥글게
  /// - Parameters:
  ///   - cornerRadius: radius 값
  ///   - byRoundingCorners: radius를 적용할 corner (default: `.allCorners`)
  func roundCorners(cornerRadius: CGFloat, byRoundingCorners: UIRectCorner = [.allCorners]) {
    let path = UIBezierPath(
      roundedRect: self.bounds,
      byRoundingCorners: byRoundingCorners,
      cornerRadii: CGSize(width:cornerRadius, height: cornerRadius)
    )
    
    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = path.cgPath
    
    layer.mask = maskLayer
  }
  
  /// UIView에 그림자 추가 시 사용하는 메서드
  /// - Parameters:
  ///   - color: 그림자 색상
  ///   - opacity: 그림자 투명도 (0~1, default: 0.5)
  ///   - offset: 그림자의 위치
  ///   - radius: 그림자 흐림도 (default: 1)
  ///   - scale: 그림자 배율 (default: `true`)
  func dropShadow(
    color: UIColor,
    opacity: Float = 0.5,
    offSet: CGSize,
    radius: CGFloat = 1,
    scale: Bool = true
  ) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOpacity = opacity
    self.layer.shadowOffset = offSet
    self.layer.shadowRadius = radius
    
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
  
  /// UIView에 외곽선 추가 시 사용하는 메서드
  /// - Parameters:
  ///   - color: 외곽선 색상
  ///   - width: 외곽선 크기
  func addBorder(with color:UIColor, width: CGFloat = 1){
    self.layer.borderWidth = width
    self.layer.borderColor = color.cgColor
  }
}
