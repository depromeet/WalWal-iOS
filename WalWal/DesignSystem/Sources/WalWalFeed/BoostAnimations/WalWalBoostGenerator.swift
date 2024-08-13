//
//  WalWalBoostGenerator.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class WalWalBoostGenerator {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  
  private weak var feed: WalWalFeed?
  private var currentDetailView: UIView?
  private var currentBackgroundView: UIView?
  private var currentBlackOverlayView: UIView?
  
  private let walwalEmitter: WalWalEmitterLayer
  private let walwalBoostBorder: WalWalBoostBorder
  private let walwalBoostCenterLabel: WalWalBoostCenterLabel
  private let walwalBoostCounter: WalWalBoostCounter
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  
  init(
    feed: WalWalFeed,
    walwalEmitter: WalWalEmitterLayer,
    walwalBoostBorder: WalWalBoostBorder,
    walwalBoostCenterLabel: WalWalBoostCenterLabel,
    walwalBoostCounter: WalWalBoostCounter
  ) {
    self.feed = feed
    self.walwalEmitter = walwalEmitter
    self.walwalBoostBorder = walwalBoostBorder
    self.walwalBoostCenterLabel = walwalBoostCenterLabel
    self.walwalBoostCounter = walwalBoostCounter
    self.feedbackGenerator.prepare()
  }
  
  func startBoostAnimation(
    for gesture: UILongPressGestureRecognizer,
    in collectionView: UICollectionView
  ) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          let cell = collectionView.cellForItem(at: indexPath) as? WalWalFeedCell,
          let feedModel = feed?.feedData.value[safe: indexPath.item],
          let window = UIWindow.key else { return }
    
    let detailView = createAndConfigureDetailView(from: cell, with: feedModel)
    let backgroundView = createBackgroundView(frame: window.bounds)
    let overlayView = createOverlayView(frame: detailView.frame)
    
    addViewsToWindow(
      detailView: detailView,
      backgroundView: backgroundView,
      overlayView: overlayView,
      window: window
    )
    
    animateDetailViewAppearance(
      detailView,
      backgroundView: backgroundView,
      overlayView: overlayView
    )
    
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    currentBlackOverlayView = overlayView
    
    addTiltAnimation(to: detailView)
    setupBoostAnimationComponents(in: detailView, window: window)
  }
  
  func stopBoostAnimation() {
    guard let detailView = currentDetailView,
          let backgroundView = currentBackgroundView,
          let overlayView = currentBlackOverlayView else { return }
    
    UIView.animate(withDuration: 0.3, animations: {
      backgroundView.alpha = 0
      detailView.alpha = 0
      overlayView.alpha = 0
    }) { _ in
      backgroundView.removeFromSuperview()
      detailView.removeFromSuperview()
      overlayView.removeFromSuperview()
    }
    
    walwalBoostCenterLabel.clearExistingLabels()
    walwalBoostCounter.stopCountTimer()
    currentDetailView?.layer.removeAnimation(forKey: "tilt")
    currentDetailView = nil
    currentBackgroundView = nil
    currentBlackOverlayView = nil
    walwalBoostBorder.stopBorderAnimation()
    walwalEmitter.stopEmitting()
    
    feedbackGenerator.prepare()
  }
  
  func getCurrentCount() -> Int {
    return walwalBoostCounter.currentCount
  }
  
  private func createAndConfigureDetailView(
    from cell: WalWalFeedCell,
    with feedModel: WalWalFeedModel
  ) -> WalWalFeedCellView {
    let detailView = WalWalFeedCellView(frame: cell.frame)
    detailView.configureFeed(feedData: feedModel)
    let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
    detailView.frame = cellFrameInWindow
    return detailView
  }
  
  private func createBackgroundView(frame: CGRect) -> UIView {
    let backgroundView = UIView(frame: frame)
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView.alpha = 0
    return backgroundView
  }
  
  private func createOverlayView(frame: CGRect) -> UIView {
    let overlayView = UIView(frame: frame)
    overlayView.backgroundColor = Colors.white.color
    return overlayView
  }
  
  private func addViewsToWindow(
    detailView: UIView,
    backgroundView: UIView,
    overlayView: UIView,
    window: UIWindow
  ) {
    window.addSubview(overlayView)
    window.addSubview(backgroundView)
    window.addSubview(detailView)
  }
  
  private func animateDetailViewAppearance(
    _ detailView: UIView,
    backgroundView: UIView,
    overlayView: UIView
  ) {
    detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    UIView.animate(withDuration: 0.3) {
      backgroundView.alpha = 1
      overlayView.alpha = 1
      detailView.transform = .identity
    }
  }
  
  private func setupBoostAnimationComponents(in detailView: UIView, window: UIWindow) {
    walwalBoostBorder.addBorderLayer(to: detailView)
    walwalBoostBorder.startBorderAnimation(borderColor: Colors.yellow.color)
    
    let burstCase = [
      WalWalBurstString.cute,
      WalWalBurstString.cool,
      WalWalBurstString.lovely
    ].randomElement() ?? .cute
    
    walwalBoostCenterLabel.updateCenterLabels(
      with: burstCase.normalText,
      in: detailView,
      window: window,
      burstMode: burstCase
    )
    
    walwalBoostCounter.setupCountLabel(in: window, detailView: detailView)
    walwalBoostCounter.startCountTimer(
      in: detailView,
      window: window,
      burstCase: burstCase
    ) { [weak self] count in
      guard let self = self else { return }
      self.handleCountUpdate(
        count: count,
        in: detailView,
        window: window,
        burstCase: burstCase
      )
    }
  }
  
  private func addTiltAnimation(to view: UIView) {
    let tiltAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    let frames = 144 /// 틱당 생기는 부자연스러움을 없애기 위해 144fps로 애니메이션 설정
    var values = [Double]()
    var keyTimes = [NSNumber]()
    
    for i in 0...frames {
      let progress = Double(i) / Double(frames)
      let angle = sin(progress * 2 * .pi) * (Double.pi / 24) /// 15도 각도를 1frame 만큼 각도 변환
      values.append(angle)
      keyTimes.append(NSNumber(value: progress))
    }
    
    tiltAnimation.values = values
    tiltAnimation.keyTimes = keyTimes
    tiltAnimation.duration = 0.3 /// 144프레임의 애니메이션을 0.3초 동안
    tiltAnimation.repeatCount = .infinity /// 무한 반복
    
    view.layer.add(tiltAnimation, forKey: "tilt")
  }
  
  private func handleCountUpdate(
    count: Int,
    in detailView: UIView,
    window: UIWindow,
    burstCase: WalWalBurstString
  ) {
    feedbackGenerator.impactOccurred()
    
    if count >= 10 {
      walwalEmitter.configureEmitter(
        in: detailView,
        positionRatio: CGPoint(x: 0.5, y: 0.5),
        sizeRatio: CGSize(width: 0.5, height: 0.5)
      )
      walwalEmitter.startEmitting(rate: 30)
      detailView.layer.addSublayer(walwalEmitter)
    }
    
    switch count {
    case 50:
      walwalBoostCenterLabel.updateCenterLabels(
        with: burstCase.goodText,
        in: detailView,
        window: window,
        burstMode: burstCase
      )
      walwalBoostBorder.startBorderAnimation(borderColor: Colors.walwalOrange.color)
    case 100:
      walwalBoostCenterLabel.updateCenterLabels(
        with: burstCase.greatText,
        in: detailView, window: window,
        burstMode: burstCase
      )
      walwalBoostBorder.startBorderAnimation(borderColor: .red)
    case 150:
      walwalBoostBorder.startBorderAnimation(borderColor: .clear, isRainbow: true)
    default:
      break
    }
  }
}
