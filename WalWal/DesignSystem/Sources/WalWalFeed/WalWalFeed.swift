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
  
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  private var longPressGesture: UILongPressGestureRecognizer!
  private var currentDetailView: WalWalFeedCellView?
  private var currentBackgroundView: UIView?
  private var borderLayer: CAShapeLayer?
  private var borderAnimation: CABasicAnimation?
  private let heartEmitter = CAEmitterLayer()
  private let heartCell = CAEmitterCell()
  private var isBorderFilled: Bool = false
  
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
      presentDetailView(for: gesture)
      startBorderAnimation()
      startHeartAnimation()
    case .ended, .cancelled:
      dismissDetailView()
      stopBorderAnimation()
      stopHeartAnimation()
    default:
      break
    }
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
    
    window.addSubview(backgroundView)
    window.addSubview(detailView)
    
    detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    
    UIView.animate(withDuration: 0.3) {
      backgroundView.alpha = 1
      detailView.transform = .identity
    }
    
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    
    currentDetailView = detailView
    currentBackgroundView = backgroundView
    
    addBorderLayer(to: detailView)
    startHeartAnimation()
  }
  
  private func addBorderLayer(to view: UIView) {
    let borderLayer = CAShapeLayer()
    let cornerRadius: CGFloat = 20
    let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
    borderLayer.path = path.cgPath
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = ResourceKitAsset.Colors.walwalOrange.color.cgColor
    borderLayer.lineWidth = 3
    borderLayer.strokeEnd = 0
    view.layer.addSublayer(borderLayer)
    
    self.borderLayer = borderLayer
  }
  
  private func startBorderAnimation() {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 1.0 // 1초 동안 애니메이션 진행
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    
    animation.delegate = self
    
    borderLayer?.add(animation, forKey: "borderAnimation")
    borderAnimation = animation
  }
  
  private func stopBorderAnimation() {
    borderLayer?.removeAllAnimations()
    borderLayer?.removeFromSuperlayer()
    borderLayer = nil
    borderAnimation = nil
    isBorderFilled = false
  }
  
  private func dismissDetailView() {
    guard let detailView = currentDetailView,
          let backgroundView = currentBackgroundView else { return }
    
    UIView.animate(withDuration: 0.3, animations: {
      backgroundView.alpha = 0
      detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }) { _ in
      backgroundView.removeFromSuperview()
      detailView.removeFromSuperview()
      self.currentDetailView = nil
      self.currentBackgroundView = nil
      self.stopBorderAnimation()
    }
  }
  
  private func setupHeartEmitter() {
      heartEmitter.emitterShape = .point
      heartEmitter.emitterMode = .outline
      heartEmitter.renderMode = .additive
      
      heartCell.contents = ResourceKitAsset.Sample.walwalEmitterDog.image.cgImage
      heartCell.scale = 0.2
      heartCell.scaleRange = 0.1
      heartCell.scaleSpeed = 0.2 // 시간이 지날수록 크기가 작아짐
      heartCell.lifetime = 2.0
      heartCell.lifetimeRange = 0.5
      heartCell.birthRate = 0 // 초기에는 0으로 설정
      heartCell.velocity = 200 // 속도 증가
      heartCell.velocityRange = 50
      heartCell.emissionRange = .pi * 2 // 360도 전 방향으로 발사
      heartCell.spin = 3.14
      heartCell.spinRange = 6.28
      heartCell.alphaSpeed = -0.5 // 시간이 지날수록 투명해짐
      
      heartEmitter.emitterCells = [heartCell]
  }
  
  private func startHeartAnimation() {
    guard let detailView = currentDetailView else { return }
    
    // 이미터 위치를 detailView의 중앙 하단으로 설정
    heartEmitter.emitterPosition = CGPoint(x: detailView.bounds.width / 2, y: detailView.bounds.height / 2)
    heartEmitter.emitterSize = CGSize(width: detailView.bounds.width, height: 1)
    
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
