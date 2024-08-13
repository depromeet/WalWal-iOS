//
//  WalWalEmitterLayer.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

final class WalWalEmitterLayer: CAEmitterLayer {
  
  private let walwalCell: WalWalEmitterCell
  
  /// 방출기 (Emitter)의 모양을 만드는 initialization
  /// - Parameters:
  ///   - cell: Layer에 올리는 WalWalEmitterCell
  ///   - emitterShape: 방출기의 모양
  ///   - emitterMode: 방출기의 모드
  ///   - renderMode: 렌더링 모드
  init(
    cell: WalWalEmitterCell,
    emitterShape: CAEmitterLayerEmitterShape = .sphere,
    emitterMode: CAEmitterLayerEmitterMode = .outline,
    renderMode: CAEmitterLayerRenderMode = .additive
  ) {
    self.walwalCell = cell
    super.init()
    
    self.emitterShape = emitterShape
    self.emitterMode = emitterMode
    self.renderMode = renderMode
    self.emitterCells = [walwalCell]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureEmitter(
    in view: UIView,
    positionRatio: CGPoint = CGPoint(x: 0.5, y: 0.5),
    sizeRatio: CGSize = CGSize(width: 0.5, height: 0.5)
  ) {
    emitterPosition = CGPoint(
      x: view.bounds.width * positionRatio.x,
      y: view.bounds.height * positionRatio.y
    )
    emitterSize = CGSize(
      width: view.bounds.width * sizeRatio.width,
      height: view.bounds.height * sizeRatio.height
    )
  }
  
  func startEmitting(rate: Float = 30) {
    walwalCell.startEmitting(rate: rate)
  }
  
  func stopEmitting() {
    walwalCell.stopEmitting()
  }
}
