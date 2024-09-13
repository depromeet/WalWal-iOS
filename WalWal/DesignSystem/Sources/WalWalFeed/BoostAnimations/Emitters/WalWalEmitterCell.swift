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
    image: UIImage = ResourceKitAsset.Sample.walwalEmitterDog.image,
    scale: CGFloat = 1.0,
    scaleRange: CGFloat = 0.99,
    scaleSpeed: CGFloat = -0.01,
    lifetime: Float = 1.0,
    lifetimeRange: Float = 0,
    birthRate: Float = 0,
    velocity: CGFloat = 1000,  // 위로 솟구치는 속도
    velocityRange: CGFloat = 1,
    emissionLongitude: CGFloat = -.pi / 2,  // 위쪽으로 방출
    emissionRange: CGFloat = .pi / 4,  // 분수대 모양처럼 좁게 방출
    yAcceleration: CGFloat = 4000,  // 중력으로 파티클이 아래로 떨어짐
    spin: CGFloat = 0,
    spinRange: CGFloat = .pi,
    alphaSpeed: Float = 0,  // 시간이 지나면서 파티클이 점점 투명해짐
    alphaRange: Float = 0,
    rotationRange: CGFloat = 80  // ±40도 범위
  ) {
    super.init()
    
    self.contents = image.cgImage
    self.scale = scale
    self.scaleRange = scaleRange
    self.scaleSpeed = scaleSpeed  // 시간이 지나면서 파티클이 점점 작아짐
    self.lifetime = lifetime
    self.lifetimeRange = lifetimeRange
    self.birthRate = birthRate
    self.velocity = velocity
    self.velocityRange = velocityRange
    self.emissionLongitude = emissionLongitude  // 파티클이 위쪽으로 방출됨
    self.emissionRange = emissionRange  // 분수대 모양처럼 퍼짐
    self.yAcceleration = yAcceleration  // 중력 적용 (양수 값으로 설정)
    self.spin = spin
    self.spinRange = spinRange
    self.alphaSpeed = alphaSpeed
    self.alphaRange = alphaRange
    
    self.color = UIColor.white.withAlphaComponent(1.0).cgColor
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startEmitting(rate: Float = 20) {
    birthRate = 18
  }
  
  func stopEmitting() {
    birthRate = 0
  }
}
