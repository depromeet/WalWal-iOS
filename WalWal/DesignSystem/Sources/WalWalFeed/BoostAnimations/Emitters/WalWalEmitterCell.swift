//
//  WalWalEmitterCell.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class WalWalEmitterCell: CAEmitterCell {
  
  /// WalWalEmitterLayer에 올릴 Cell의 initialization
  /// - Parameters:
  ///   - image: 파티클의 이미지
  ///   - scale: 파티클의 기본 크기 (1.0 = 100%)
  ///   - scaleRange: 파티클 크기의 변화 범위
  ///   - lifetime: 파티클의 수명 (초)
  ///   - lifetimeRange: 파티클 수명의 변화 범위 (초)
  ///   - birthRate: 초기 파티클 생성 속도 (개/초)
  ///   - velocity: 파티클의 초기 속도
  ///   - velocityRange: 파티클 속도의 변화 범위
  ///   - emissionRange: 파티클 방출 각도 범위 (라디안)
  ///   - spin: 파티클의 회전 속도 (라디안/초)
  ///   - spinRange: 파티클 회전 속도의 변화 범위 (라디안/초)
  ///   - alphaSpeed: 파티클 투명도의 변화 속도 (초당)
  init(
    /// 파티클의 이미지
    image: UIImage = ResourceKitAsset.Sample.walwalEmitterDog.image,
    scale: CGFloat = 0.8,
    scaleRange: CGFloat = 0.5,
    lifetime: Float = 2.0,
    lifetimeRange: Float = 0.5,
    birthRate: Float = 0,
    velocity: CGFloat = 800,
    velocityRange: CGFloat = 50,
    emissionRange: CGFloat = .pi * 2,
    spin: CGFloat = 3.14,
    spinRange: CGFloat = 6.28,
    alphaSpeed: Float = -0.5
  ) {
    super.init()
    
    self.contents = image.cgImage
    self.scale = scale
    self.scaleRange = scaleRange
    self.lifetime = lifetime
    self.lifetimeRange = lifetimeRange
    self.birthRate = birthRate
    self.velocity = velocity
    self.velocityRange = velocityRange
    self.emissionRange = emissionRange
    self.spin = spin
    self.spinRange = spinRange
    self.alphaSpeed = alphaSpeed
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startEmitting(rate: Float = 30) {
    birthRate = rate
  }
  
  func stopEmitting() {
    birthRate = 0
  }
}
