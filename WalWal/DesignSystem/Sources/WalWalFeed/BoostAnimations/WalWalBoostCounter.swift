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
  private var borderLabel: UILabel?
  
  func setupCountLabel(in window: UIWindow, detailView: UIView) {
    currentCount = 0
    countLabel = UILabel()
    countLabel?.textAlignment = .center
    countLabel?.sizeToFit()
    
    borderLabel = UILabel()
    borderLabel?.textAlignment = .center
    borderLabel?.sizeToFit()
    
    updateCountLabelText()
    
    countLabel?.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 40.adjusted)
    countLabel?.alpha = 1
    borderLabel?.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 40.adjusted)
    borderLabel?.alpha = 1
    window.addSubview(borderLabel!)
    window.addSubview(countLabel!)
    updateCountLabelPosition(detailView: detailView)
  }
  
  func startCountTimer(in detailView: UIView, window: UIWindow, countUpdateHandler: @escaping (Int) -> Void) {
    countTimer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { [weak self] timer in
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
    borderLabel?.removeFromSuperview()
    countLabel = nil
    borderLabel = nil
  }
  
  private func updateCountLabelText() {
    let attrString = NSAttributedString(
      string: "\(currentCount)",
      attributes: [
        .font: Fonts.LotteriaChab.H1,
        .foregroundColor: Colors.white.color,
      ]
    )
    countLabel?.attributedText = attrString
    countLabel?.textAlignment = .center
    countLabel?.sizeToFit()
    countLabel?.frame = countLabel?.frame.insetBy(dx: -6, dy: -6) ?? .zero
    
    let borderAttrString = NSAttributedString(
      string: "\(currentCount)",
      attributes: [
        .strokeColor: Colors.black.color,
        .foregroundColor: Colors.black.color,
        .strokeWidth: -24,
        .font:  Fonts.LotteriaChab.H1
      ]
    )
    borderLabel?.attributedText = borderAttrString
    borderLabel?.textAlignment = .center
    borderLabel?.sizeToFit()
    borderLabel?.frame = borderLabel?.frame.insetBy(dx: -6, dy: -6) ?? .zero
  }
  
  private func updateCountLabelPosition(detailView: UIView) {
    guard let countLabel = countLabel else { return }
    guard let borderLabel = borderLabel else { return }
    
    let labelSize = countLabel.bounds.size
    let borderLabelSize = borderLabel.bounds.size
    let detailViewCenter = detailView.center
    
    borderLabel.center = CGPoint(
      x: detailViewCenter.x,
      y: detailViewCenter.y - 50.adjusted - borderLabelSize.height / 2
    )
    countLabel.center = CGPoint(
      x: detailViewCenter.x,
      y: detailViewCenter.y - 50.adjusted - labelSize.height / 2
    )
  }
}
