//
//  WalWalBoostCounter.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class WalWalBoostCounter {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  private(set) var currentCount: Int = 0
  private var countTimer: Timer?
  private var countLabel: UILabel?
  
  func setupCountLabel(in window: UIWindow, detailView: UIView) {
    currentCount = 0
    countLabel = UILabel()
    updateCountLabelText()
    countLabel?.textAlignment = .center
    countLabel?.sizeToFit()
    countLabel?.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 40)
    countLabel?.alpha = 1
    window.addSubview(countLabel!)
    updateCountLabelPosition(detailView: detailView)
  }
  
  func startCountTimer(in detailView: UIView, window: UIWindow, burstCase: WalWalBurstString, countUpdateHandler: @escaping (Int) -> Void) {
    countTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
      guard let self = self else { return }
      self.currentCount += 1
      self.updateCountLabelText()
      self.updateCountLabelPosition(detailView: detailView)
      countUpdateHandler(self.currentCount)
    }
  }
  
  func stopCountTimer() {
    countTimer?.invalidate()
    countTimer = nil
    countLabel?.removeFromSuperview()
    countLabel = nil
  }
  
  private func updateCountLabelText() {
    let attrString = NSAttributedString(
      string: "\(currentCount)",
      attributes: [
        .strokeColor: Colors.black.color,
        .foregroundColor: Colors.white.color,
        .strokeWidth: -8,
        .font: Fonts.LotteriaChab.H1
      ]
    )
    countLabel?.attributedText = attrString
    countLabel?.sizeToFit()
  }
  
  private func updateCountLabelPosition(detailView: UIView) {
    guard let countLabel = countLabel else { return }
    
    let labelSize = countLabel.bounds.size
    let detailViewCenter = detailView.center
    
    countLabel.center = CGPoint(
      x: detailViewCenter.x,
      y: detailViewCenter.y - 50 - labelSize.height / 2
    )
  }
}
