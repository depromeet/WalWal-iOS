//
//  WalWalFeed.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class WalWalFeed: UIView {
  
  public enum WalWalBurstString {
    case cute
    case cool
    case lovely
    
    var BurstFond: UIFont {
      switch self {
      case .cute: return ResourceKitFontFamily.LotteriaChab.Buster_Cute
      case .cool: return ResourceKitFontFamily.LotteriaChab.Buster_Cool
      case .lovely: return ResourceKitFontFamily.LotteriaChab.Buster_Lovely
      }
    }
    
    var normalText: String {
      switch self {
      case .cute: return "귀여워!"
      case .cool: return "멋져!"
      case .lovely: return "사랑스러워!"
      }
    }
    
    var goodText: String {
      switch self {
      case .cute: return "너무 귀여워!"
      case .cool: return "너무 멋져!"
      case .lovely: return "너무 사랑스러워!"
      }
    }
    
    var greatText: String {
      switch self {
      case .cute: return "너무너무 귀여워!"
      case .cool: return "너무너무 멋져!"
      case .lovely: return "너무너무 사랑스러워!"
      }
    }
  }
  
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  private var longPressGesture: UILongPressGestureRecognizer!
  private var currentDetailView: WalWalFeedCellView?
  private var currentBackgroundView: UIView?
  private var currentBlackOverayView: UIView?
  private var borderLayer: CAShapeLayer?
  private var borderAnimation: CABasicAnimation?
  private var centerLabels: [UILabel] = []
  private var centerShadowLabels: [UILabel] = []
  private var countLabel: UILabel?
  private var countTimer: Timer?
  private var count: Int = 0
  private let heartEmitter = CAEmitterLayer()
  private let heartCell = CAEmitterCell()
  private var isBorderFilled: Bool = false
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  
  private let disposeBag = DisposeBag()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 342, height: 470)
    flowLayout.minimumLineSpacing = 14
    
    $0.collectionViewLayout = flowLayout
    $0.backgroundColor = .clear
    $0.register(WalWalFeedCell.self, forCellWithReuseIdentifier: "WalWalFeedCell")
    $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
  }
  
  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureCollectionView()
    setAttributes()
    setLayouts()
    bindFeedData()
    configureLongPressGesture()
  }
  
  public init(feedData: [WalWalFeedModel]) {
    super.init(frame: .zero)
    configureCollectionView()
    setAttributes()
    setLayouts()
    bindFeedData()
    configureLongPressGesture()
    self.feedData.accept(feedData)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout()
    setupHeartEmitter()
  }
  
  // MARK: - Methods
  private func setAttributes() {
    
  }
  
  private func setLayouts() {
    flex.define { flex in
      flex.addItem(collectionView)
        .grow(1)
    }
  }
  
  private func configureCollectionView() {
    // Configure the collection view layout here if needed
  }
  
  private func configureLongPressGesture() {
    longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    collectionView.addGestureRecognizer(longPressGesture)
  }
  
  private func bindFeedData() {
    feedData
      .bind(to: collectionView.rx.items(
        cellIdentifier: "WalWalFeedCell",
        cellType: WalWalFeedCell.self
      )) { index, model, cell in
        cell.configureCell(feedData: model)
      }
      .disposed(by: disposeBag)
  }
  
  @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      feedbackGenerator.prepare()
      presentDetailView(for: gesture)
    case .ended, .cancelled:
      dismissDetailView()
      stopBorderAnimation()
      stopHeartAnimation()
      updateNewBusterCount(for: gesture)
    default:
      break
    }
  }
  
  private func updateNewBusterCount(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          var feedModel = feedData.value[safe: indexPath.item] else { return }
    
    feedModel.boostCount += count
    
    var updatedFeedData = feedData.value
    updatedFeedData[indexPath.item] = feedModel
    feedData.accept(updatedFeedData)
  }

  private func presentDetailView(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          let cell = collectionView.cellForItem(at: indexPath) as? WalWalFeedCell,
          let feedModel = feedData.value[safe: indexPath.item] else { return }
    
    let detailView = WalWalFeedCellView(frame: cell.frame)
    detailView.configureFeed(feedData: feedModel)
    
    let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
    detailView.frame = cellFrameInWindow
    
    guard let window = UIWindow.key else { return }
    
    let backgroundView = UIView(frame: window.bounds)
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView.alpha = 0
    
    let overlayView = UIView(frame: cellFrameInWindow)
    overlayView.backgroundColor = ResourceKitAsset.Colors.black.color
    
    window.addSubview(backgroundView)
    window.addSubview(overlayView)
    window.addSubview(detailView)
    
    let selectCase = [WalWalBurstString.cute, WalWalBurstString.cool, WalWalBurstString.lovely].randomElement() ?? .cute
    // 중앙에 각 글자를 개별적으로 애니메이션 처리
    updateCenterLabels(with: selectCase.normalText, in: detailView, window: window, burstMode: selectCase)
    
    // 카운트 라벨 추가
    count = 0
    let countLabel = UILabel()
    let attrString = NSAttributedString(
      string: "\(count)",
      attributes: [
        NSAttributedString.Key.strokeColor: ResourceKitAsset.Colors.black.color,
        NSAttributedString.Key.foregroundColor: ResourceKitAsset.Colors.white.color,
        NSAttributedString.Key.strokeWidth: -7.0,
        NSAttributedString.Key.font: ResourceKitFontFamily.LotteriaChab.H1
      ]
    )
    countLabel.attributedText = attrString
    countLabel.textAlignment = .center
    countLabel.sizeToFit()
    countLabel.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 40)
    countLabel.alpha = 0 // Initially hidden
    window.addSubview(countLabel)
    self.countLabel = countLabel
    
    startCountTimer(in: detailView, window: window, burstCase: selectCase)
    
    detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    
    UIView.animate(withDuration: 0.3) {
      backgroundView.alpha = 1
      overlayView.alpha = 1
      detailView.transform = .identity
    }
    
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    currentBlackOverayView = overlayView
    
    addBorderLayer(to: detailView)
    startBorderAnimation(borderColor: ResourceKitAsset.Colors.yellow.color)
  }
  
  private func updateCenterLabels(with text: String, in detailView: UIView, window: UIWindow, burstMode: WalWalBurstString) {
    // Remove existing labels
    for label in centerLabels {
      label.removeFromSuperview()
    }
    for label in centerShadowLabels {
      label.removeFromSuperview()
    }
    centerLabels.removeAll()
    centerShadowLabels.removeAll()
    
    // Create new labels
    let words = text.split(separator: " ")
    var lines: [[String]] = [[]]
    
    let labelFont = burstMode.BurstFond
    let windowWidth = window.bounds.width
    var currentLineWidth: CGFloat = 0
    
    for word in words {
      let testLabel = UILabel()
      testLabel.attributedText = NSAttributedString(
        string: String(word),
        attributes: [
          NSAttributedString.Key.font: labelFont
        ]
      )
      testLabel.sizeToFit()
      let wordWidth = testLabel.bounds.width
      
      if currentLineWidth + wordWidth > windowWidth {
        lines.append([String(word)])
        currentLineWidth = wordWidth
      } else {
        lines[lines.count - 1].append(String(word))
        currentLineWidth += wordWidth // Add space for next word
      }
    }
    
    let countLabelY = detailView.center.y - 40
    var startY = countLabelY + 60 // Adjust this value to ensure proper spacing
    
    for line in lines {
      let lineText = line.joined(separator: " ")
      let characters = Array(lineText)
      var delay: TimeInterval = 0
      var totalWidth: CGFloat = 0
      
      for char in characters {
        let testLabel = UILabel()
        testLabel.attributedText = NSAttributedString(
          string: String(char),
          attributes: [
            NSAttributedString.Key.font: labelFont
          ]
        )
        testLabel.sizeToFit()
        totalWidth += testLabel.bounds.width
      }
      
      var startX = detailView.center.x - totalWidth / 2
      
      for char in characters {
        let shadowLabel = UILabel()
        let shadowAttrString = NSAttributedString(
          string: String(char),
          attributes: [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -4,
            NSAttributedString.Key.font: labelFont
          ]
        )
        shadowLabel.attributedText = shadowAttrString
        shadowLabel.textAlignment = .center
        shadowLabel.sizeToFit()
        shadowLabel.alpha = 0
        
        let label = UILabel()
        let attrString = NSAttributedString(
          string: String(char),
          attributes: [
            NSAttributedString.Key.strokeColor: ResourceKitAsset.Colors.black.color,
            NSAttributedString.Key.font: labelFont,
            NSAttributedString.Key.foregroundColor: ResourceKitAsset.Colors.white.color,
            NSAttributedString.Key.strokeWidth: -4,
          ]
        )
        label.attributedText = attrString
        label.textAlignment = .center
        label.sizeToFit()
        label.alpha = 0
        
        centerLabels.append(label)
        centerShadowLabels.append(shadowLabel)
        
        let initialY = startY + window.bounds.height / 2
        shadowLabel.center = CGPoint(x: startX + shadowLabel.bounds.width / 2 + 4, y: initialY + 4)
        label.center = CGPoint(x: startX + label.bounds.width / 2, y: initialY)
        startX += label.bounds.width
        window.addSubview(shadowLabel)
        window.addSubview(label)
        
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
          shadowLabel.alpha = 1
          shadowLabel.center.y = startY + 4
          label.alpha = 1
          label.center.y = startY
        }, completion: nil)
        
        delay += 0.1
      }
      
      startY += labelFont.lineHeight - (labelFont.lineHeight*0.25)
    }
  }
  
  private func addBorderLayer(to view: UIView) {
    let borderLayer = CAShapeLayer()
    let cornerRadius: CGFloat = 20
    let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
    borderLayer.path = path.cgPath
    borderLayer.fillColor = UIColor.clear.cgColor
    //    borderLayer.strokeColor = ResourceKitAsset.Colors.walwalOrange.color.cgColor
    borderLayer.lineWidth = 5
    borderLayer.strokeEnd = 0
    view.layer.addSublayer(borderLayer)
    
    self.borderLayer = borderLayer
  }
  
  private func startBorderAnimation(borderColor: UIColor, isRainbow: Bool = false) {
    if isRainbow {
      let colors: [CGColor] = [
        UIColor.red.cgColor,
        UIColor.orange.cgColor,
        UIColor.yellow.cgColor,
        UIColor.green.cgColor,
        UIColor.blue.cgColor,
        UIColor.purple.cgColor,
        UIColor.red.cgColor // 마지막 색상을 처음 색상과 동일하게 하여 원활한 반복
      ]
      
      let rainbowAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
      rainbowAnimation.values = colors
      rainbowAnimation.keyTimes = [0, 0.17, 0.34, 0.51, 0.68, 0.85, 1.0]
      rainbowAnimation.duration = 5.0 // 애니메이션 지속 시간
      rainbowAnimation.repeatCount = .infinity
      
      borderLayer?.add(rainbowAnimation, forKey: "rainbowBorderAnimation")
      
      // 좌우로 기울이는 애니메이션 추가
      let tiltAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      
      let frames = 60
      var values = [Double]()
      var keyTimes = [NSNumber]()
      
      for i in 0...frames {
        let progress = Double(i) / Double(frames)
        let angle = sin(progress * 2 * .pi) * (Double.pi / 16)
        values.append(angle)
        keyTimes.append(NSNumber(value: progress))
      }
      
      tiltAnimation.values = values
      tiltAnimation.keyTimes = keyTimes
      tiltAnimation.duration = 1.0
      tiltAnimation.repeatCount = .infinity
      
      currentDetailView?.layer.add(tiltAnimation, forKey: "tilt")
    } else {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0
      animation.toValue = 1
      animation.duration = 2.5
      animation.isRemovedOnCompletion = false
      animation.fillMode = .forwards
      
      animation.delegate = self
      
      borderLayer?.strokeColor = borderColor.cgColor
      borderLayer?.add(animation, forKey: "borderAnimation")
      borderAnimation = animation
    }
  }
  
  private func stopBorderAnimation() {
    borderLayer?.removeAllAnimations()
    borderLayer?.removeFromSuperlayer()
    borderLayer = nil
    borderAnimation = nil
    isBorderFilled = false
  }
  
  private func startCountTimer(in detailView: UIView, window: UIWindow, burstCase: WalWalBurstString) {
    countTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
      guard let self = self else { return }
      self.count += 1
      let attrString = NSAttributedString(
        string: "\(self.count)",
        attributes: [
          NSAttributedString.Key.strokeColor: ResourceKitAsset.Colors.black.color,
          NSAttributedString.Key.foregroundColor: ResourceKitAsset.Colors.white.color,
          NSAttributedString.Key.strokeWidth: -6.73,
          NSAttributedString.Key.font: ResourceKitFontFamily.LotteriaChab.H1
        ]
      )
      self.countLabel?.attributedText = attrString
      self.countLabel?.sizeToFit()
      self.countLabel?.center = CGPoint(x: detailView.center.x, y: detailView.center.y - 50)
      
      if self.count >= 10 {
        if self.countLabel?.alpha == 0 {
          UIView.animate(withDuration: 1.0) {
            self.countLabel?.alpha = 1
          }
          self.startHeartAnimation()
        }
      }
      self.feedbackGenerator.impactOccurred()
      if self.count == 50 {
        self.updateCenterLabels(with: burstCase.goodText, in: detailView, window: window, burstMode: burstCase)
        self.startBorderAnimation(borderColor: ResourceKitAsset.Colors.walwalOrange.color)
      } else if self.count == 100 {
        self.updateCenterLabels(with: burstCase.greatText, in: detailView, window: window, burstMode: burstCase)
        self.startBorderAnimation(borderColor: .red)
      } else if self.count == 150 { // 세 번째 게이지가 다 찰 때
        self.startBorderAnimation(borderColor: .clear, isRainbow: true)
      }
    }
  }

  
  private func stopCountTimer() {
    countTimer?.invalidate()
    countTimer = nil
  }
  
  private func dismissDetailView() {
    guard let detailView = currentDetailView,
          let backgroundView = currentBackgroundView,
          let overlayView = currentBlackOverayView else { return }
    
    backgroundView.removeFromSuperview()
    detailView.removeFromSuperview()
    overlayView.removeFromSuperview()
    
    for label in centerLabels {
      label.removeFromSuperview()
    }
    for label in centerShadowLabels {
      label.removeFromSuperview()
    }
    centerLabels.removeAll()
    centerShadowLabels.removeAll()
    countLabel?.removeFromSuperview()
    countLabel = nil
    stopCountTimer()
    
    self.currentDetailView = nil
    self.currentBackgroundView = nil
    self.currentBlackOverayView = nil
    self.stopBorderAnimation()
    self.stopHeartAnimation()
  }
  
  private func setupHeartEmitter() {
    heartEmitter.emitterShape = .point
    heartEmitter.emitterMode = .outline
    heartEmitter.renderMode = .additive
    
    heartCell.contents = ResourceKitAsset.Sample.walwalEmitterDog.image.cgImage
    heartCell.scale = 0.8
    heartCell.scaleRange = 0.5
    heartCell.lifetime = 2.0
    heartCell.lifetimeRange = 0.5
    heartCell.birthRate = 0 // 초기에는 0으로 설정
    heartCell.velocity = 800 // 속도 증가
    heartCell.velocityRange = 50
    heartCell.emissionRange = .pi * 2 // 360도 전 방향으로 발사
    heartCell.spin = 3.14
    heartCell.spinRange = 6.28
    heartCell.alphaSpeed = -0.5 // 시간이 지날수록 투명해짐
    
    heartEmitter.emitterCells = [heartCell]
  }
  
  private func startHeartAnimation() {
    guard let detailView = currentDetailView else { return }
    
    // 이미터의 모양을 원으로 설정
    heartEmitter.emitterShape = .sphere
    
    // 이미터의 중심 위치를 detailView의 중앙으로 설정
    heartEmitter.emitterPosition = CGPoint(x: detailView.bounds.width / 2, y: detailView.bounds.height / 2)
    
    // 이미터의 크기를 반지름 (width / 4)의 원으로 설정
    heartEmitter.emitterSize = CGSize(width: detailView.bounds.width / 2, height: detailView.bounds.width / 2)
    
    // birthRate를 설정하여 애니메이션 시작
    heartCell.birthRate = 30
    
    detailView.layer.addSublayer(heartEmitter)
  }
  
  private func stopHeartAnimation() {
    heartCell.birthRate = 0
    heartEmitter.removeFromSuperlayer()
  }
}

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension WalWalFeed: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      isBorderFilled = true
    }
  }
}
