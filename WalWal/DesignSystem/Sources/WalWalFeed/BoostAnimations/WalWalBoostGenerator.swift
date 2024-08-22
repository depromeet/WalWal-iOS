//
//  WalWalBoostGenerator.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift

struct BoostResult {
    let indexPath: IndexPath
    let count: Int
}

final class WalWalBoostGenerator {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  
  private weak var feed: WalWalFeed?
  private var currentDetailView: UIView?
  private var currentBlackOverlayView: UIView?
  private var currentIndexPath: IndexPath?
  
  private let walwalEmitter: WalWalEmitterLayer
  private let walwalBoostBorder: WalWalBoostBorder
  private let walwalBoostCenterLabel: WalWalBoostCenterLabel
  private let walwalBoostCounter: WalWalBoostCounter
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  
  let boostFinished = PublishSubject<BoostResult>()
  var isEndedLongPress = false
  
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
  
  /// 부스트 애니메이션 시작
  func startBoostAnimation(
    for gesture: UILongPressGestureRecognizer,
    in collectionView: UICollectionView
  ) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          let cell = collectionView.cellForItem(at: indexPath) as? WalWalFeedCell,
          let feedModel = feed?.feedData.value[safe: indexPath.item],
          let window = UIWindow.key else { return }
    
    currentIndexPath = indexPath
    
    let detailView = createAndConfigureDetailView(from: cell, with: feedModel)
    let overlayView = createOverlayView(frame: detailView.frame)
    
    addViewsToWindow(
      detailView: detailView,
      overlayView: overlayView,
      window: window
    )
    
    animateDetailViewAppearance(
      detailView,
      window: window
    )
    
    currentDetailView = detailView
    currentBlackOverlayView = overlayView
  }
  
  /// 부스트 애니메이션 종료
  func stopBoostAnimation() {
    guard let detailView = currentDetailView,
          let overlayView = currentBlackOverlayView,
          let indexPath = currentIndexPath else { return }
    
    UIView.animate(withDuration: 0.3, animations: {
      detailView.alpha = 0
      overlayView.alpha = 0
    }) { _ in
      detailView.removeFromSuperview()
      overlayView.removeFromSuperview()
    }
    
    walwalBoostCenterLabel.clearExistingLabels()
    walwalBoostCounter.stopCountTimer()
    walwalBoostBorder.stopBorderAnimation()
    currentDetailView = nil
    currentBlackOverlayView = nil
    walwalEmitter.stopEmitting()
    walwalEmitter.removeFromSuperlayer()
    
    boostFinished.onNext(
      BoostResult(
        indexPath: indexPath,
        count: walwalBoostCounter.currentCount
      )
    )
    
    feedbackGenerator.prepare()
  }
  
  func getCurrentCount() -> Int {
    return walwalBoostCounter.currentCount
  }
}

// MARK: - Private Methods

extension WalWalBoostGenerator {
  private func createAndConfigureDetailView(
    from cell: WalWalFeedCell,
    with feedModel: WalWalFeedModel
  ) -> WalWalFeedCellView {
    let detailView = WalWalFeedCellView(frame: cell.frame)
    detailView.configureFeed(feedData: feedModel, isBoost: true)
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
    overlayView: UIView,
    window: UIWindow
  ) {
    window.addSubview(overlayView)
    window.addSubview(detailView)
  }
  
  private func animateDetailViewAppearance(
    _ detailView: UIView,
    window: UIWindow
  ) {
    detailView.transform = .identity
    UIView.animateKeyframes(
      withDuration: 0.5,
      delay: 0,
      options: [],
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
          detailView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98).translatedBy(x: 0, y: 2)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
          detailView.transform = .identity
        }
      }
    ) { _ in
      /// 애니메이션 완료 후 추가 작업이 필요한 경우 여기에 구현
    }
    
    /// DetailView가 작아진 후 다시 커지기 시작할 때 다른 애니메이션 시작
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
      guard let self = self else { return }
      if isEndedLongPress { return }
      self.addTiltAnimation(to: detailView)
      self.setupBoostAnimationComponents(in: detailView, window: window)
    }
  }
  
  private func setupBoostAnimationComponents(in detailView: UIView, window: UIWindow) {
    walwalBoostBorder.addBorderLayer(to: detailView)
    walwalBoostBorder.startBorderAnimation()
    
    walwalBoostCenterLabel.updateCenterLabels(
      with: WalWalBurstString.normalText,
      in: detailView,
      window: window
    ) { [weak self] in
      guard let self = self else { return }
      self.walwalBoostCenterLabel.disappearLabels()
    }
    
    walwalBoostCounter.setupCountLabel(in: window, detailView: detailView)
    walwalBoostCounter.startCountTimer(
      in: detailView,
      window: window
    ) { [weak self] count in
      guard let self = self else { return }
      self.handleCountUpdate(
        count: count,
        in: detailView,
        window: window
      )
    }
    
    walwalEmitter.configureEmitter(
      in: detailView,
      positionRatio: CGPoint(x: 0.5, y: 0.5),
      sizeRatio: CGSize(width: 0.5, height: 0.5)
    )
    walwalEmitter.startEmitting(rate: 10)
    detailView.layer.addSublayer(walwalEmitter)
  }
  
  private func addTiltAnimation(to view: UIView) {
    let tiltAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    let frames = 60 /// 틱당 생기는 부자연스러움을 없애기 위해 144fps로 애니메이션 설정
    var values = [Double]()
    var keyTimes = [NSNumber]()
    
    for i in 0...frames {
      let progress = Double(i) / Double(frames)
      let angle = sin(progress * 2 * .pi) * (Double.pi / 180) /// 15도 각도를 1frame 만큼 각도 변환
      values.append(angle)
      keyTimes.append(NSNumber(value: progress))
    }
    
    tiltAnimation.values = values
    tiltAnimation.keyTimes = keyTimes
    tiltAnimation.duration = 0.1 /// 144프레임의 애니메이션을 0.3초 동안
    tiltAnimation.repeatCount = .infinity /// 무한 반복
    
    view.layer.add(tiltAnimation, forKey: "tilt")
  }
  
  private func handleCountUpdate(
    count: Int,
    in detailView: UIView,
    window: UIWindow
  ) {
    feedbackGenerator.impactOccurred()
    
    // 기본 방출량
    let normalRate: Float = 20
    
    // 순간적으로 방출량을 2배로 늘리는 메서드
    func temporarilyIncreaseRate(_ rate: Float, duration: TimeInterval) {
      walwalEmitter.startEmitting(rate: rate)
      DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
        self?.walwalEmitter.startEmitting(rate: normalRate)  // 원래 방출량으로 돌아감
      }
    }
    
    switch count {
    case 1:
      // 1개일 때 방출량 잠깐 2배로 늘림
      temporarilyIncreaseRate(normalRate * 2, duration: 1)  // 0.5초 동안 2배로 방출
      
    case 100:
      walwalBoostBorder.startBorderAnimation(isRainbow: true)
      walwalBoostCenterLabel.updateCenterLabels(
        with: WalWalBurstString.goodText,
        in: detailView,
        window: window
      ) { [weak self] in
        guard let self = self else { return }
        self.walwalBoostCenterLabel.disappearLabels()
      }
      temporarilyIncreaseRate(normalRate * 2, duration: 1)  // 0.5초 동안 2배로 방출
      
    case 250:
      walwalBoostCenterLabel.updateCenterLabels(
        with: WalWalBurstString.greatText,
        in: detailView,
        window: window
      ) { [weak self] in
        guard let self = self else { return }
        self.walwalBoostCenterLabel.disappearLabels()
      }
      temporarilyIncreaseRate(normalRate * 2, duration: 1)  // 0.5초 동안 2배로 방출
      
    case 500:
      walwalBoostCenterLabel.updateCenterLabels(
        with: WalWalBurstString.wonderfulText,
        in: detailView,
        window: window
      ) { [weak self] in
        guard let self = self else { return }
        self.walwalBoostCenterLabel.disappearLabels()
      }
      temporarilyIncreaseRate(normalRate * 2, duration: 1)  // 0.5초 동안 2배로 방출
      
    default:
      walwalEmitter.startEmitting(rate: normalRate)  // 기본 방출량 유지
    }
  }
}
