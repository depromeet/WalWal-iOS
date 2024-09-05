//
//  WalWalBoostGenerator.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import GlobalState

import RxSwift
import Lottie

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
  private var currentBackgroundView: UIView?
  private var currentBlackOverlayView: UIView?
  private var currentIndexPath: IndexPath?
  
  private var walwalEmitter: WalWalEmitterLayer
  private let walwalBoostBorder: WalWalBoostBorder
  private let walwalBoostCenterLabel: WalWalBoostCenterLabel
  private let walwalBoostCounter: WalWalBoostCounter
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  
  let boostFinished = PublishSubject<BoostResult>()
  let isOwnFeed = PublishSubject<Bool>()
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
    
    if feedModel.authorId == GlobalState.shared.profileInfo.value.memberId {
      isOwnFeed.onNext(true)
      return
    }
    
    let detailView = createAndConfigureDetailView(from: cell, with: feedModel)
    let backgroundView = createBackgroundView(frame: window.frame)
    let overlayView = createOverlayView(frame: detailView.frame)
    
    addViewsToWindow(
      detailView: detailView,
      backgroundView: backgroundView,
      overlayView: overlayView,
      window: window
    )
    
    animateDetailViewAppearance(
      detailView,
      window: window
    )
    
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    currentBlackOverlayView = overlayView
  }
  
  /// 부스트 애니메이션 종료
  func stopBoostAnimation() {
    guard let detailView = currentDetailView,
          let backgroundView = currentBackgroundView,
          let overlayView = currentBlackOverlayView,
          let indexPath = currentIndexPath else { return }
    
    UIView.animate(withDuration: 0.3, animations: {
      detailView.alpha = 0
      backgroundView.alpha = 0
      overlayView.alpha = 0
    }) { _ in
      detailView.removeFromSuperview()
      backgroundView.removeFromSuperview()
      overlayView.removeFromSuperview()
    }
    
    walwalBoostCenterLabel.clearExistingLabels()
    walwalBoostCounter.stopCountTimer()
    walwalBoostBorder.stopBorderAnimation()
    currentDetailView = nil
    currentBackgroundView = nil
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
    detailView.configureFeed(feedData: feedModel, isBoost: true, isAlreadyExpanded: cell.feedView.isExpanded)
    
    /// 더보기를 클릭한 경우 늘리기
    if cell.feedView.isExpanded {
      detailView.isExpanded = true
      detailView.toggleContent()
      detailView.flex.layout()
    }
    let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
    detailView.frame = cellFrameInWindow
    return detailView
  }
  
  private func createBackgroundView(frame: CGRect) -> UIView {
    let backgroundView = UIView(frame: frame)
    backgroundView.backgroundColor = .clear
    backgroundView.alpha = 1
    return backgroundView
  }
  
  private func createOverlayView(frame: CGRect) -> UIView {
    let overlayView = UIView(frame: frame)
    overlayView.backgroundColor = Colors.gray150.color
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
  
  private func showFootLottie(in detailView: UIView, window: UIWindow, mode: AnimationAsset) {
    let centerLabelLottieView: LottieAnimationView = {
      let animationView = LottieAnimationView(animation: mode.animation)
      animationView.loopMode = .playOnce
      animationView.contentMode = .scaleAspectFill
      return animationView
    }()
    
//    centerLabelLottieView.center = CGPoint(x: detailView.center.x, y: detailView.center.y + 20.adjusted)
    window.addSubview(centerLabelLottieView)
    
    centerLabelLottieView.pin
      .center()
      .top(210.adjusted)
      .marginHorizontal(50.adjusted)
      .height(205.adjusted)
    
    centerLabelLottieView.layoutIfNeeded()
    
    centerLabelLottieView.play { completed in
      if completed {
        centerLabelLottieView.stop()
        window.viewWithTag(999)?.removeFromSuperview()
        centerLabelLottieView.removeFromSuperview()
      }
    }
  }
  
  private func setupBoostAnimationComponents(in detailView: UIView, window: UIWindow) {
    walwalBoostBorder.addBorderLayer(to: detailView)
    walwalBoostBorder.startBorderAnimation()
    
    showFootLottie(in: detailView, window: window, mode: AnimationAsset.cute)
    
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
    walwalEmitter.startEmitting()
    detailView.layer.addSublayer(walwalEmitter)
  }
  
  private func addTiltAnimation(to view: UIView) {
    let tiltAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    let frames = 60 /// 틱당 생기는 부자연스러움을 없애기 위해 60fps로 애니메이션 설정
    var values = [Double]()
    var keyTimes = [NSNumber]()
    
    for i in 0...frames {
      let progress = Double(i) / Double(frames)
      let angle = sin(progress * 2 * .pi) * (Double.pi / 180) * 0.66  /// 15도 각도를 1frame 만큼 각도 변환
      values.append(angle)
      keyTimes.append(NSNumber(value: progress))
    }
    
    tiltAnimation.values = values
    tiltAnimation.keyTimes = keyTimes
    tiltAnimation.duration = 0.1 /// 60fps의 애니메이션을 0.3초 동안
    tiltAnimation.repeatCount = .infinity /// 무한 반복
    
    view.layer.add(tiltAnimation, forKey: "tilt")
  }
  
  private func handleCountUpdate(
    count: Int,
    in detailView: UIView,
    window: UIWindow
  ) {
    feedbackGenerator.impactOccurred()
    switch count {
    case 100:
      walwalBoostBorder.startBorderAnimation(isRainbow: true)
      showFootLottie(in: detailView, window: window, mode: AnimationAsset.soCute)
    case 250:
      showFootLottie(in: detailView, window: window, mode: AnimationAsset.soSoCute)
    case 500:
      showFootLottie(in: detailView, window: window, mode: AnimationAsset.soSoLove)
    default:
      walwalEmitter.startEmitting()  // 기본 방출량 유지
    }
  }
}
