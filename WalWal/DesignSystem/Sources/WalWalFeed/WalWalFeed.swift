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
  
  private typealias Colors = ResourceKitAsset.Colors
  
  // MARK: - UI
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 342, height: 470)
    flowLayout.minimumLineSpacing = 14
    
    $0.collectionViewLayout = flowLayout
    $0.backgroundColor = .clear
    $0.register(WalWalFeedCell.self, forCellWithReuseIdentifier: "WalWalFeedCell")
    $0.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
  }
  
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  private let walwalBoostBorder = WalWalBoostBorder()
  
  private let walwalBoostCenterLabel = WalWalBoostCenterLabel()
  
  private let walwalBoostCounter = WalWalBoostCounter()
  
  private lazy var walwalBoostGenerater = WalWalBoostGenerator(
    feed: self,
    walwalEmitter: walwalEmitter,
    walwalBoostBorder: walwalBoostBorder,
    walwalBoostCenterLabel: walwalBoostCenterLabel,
    walwalBoostCounter: walwalBoostCounter
  )
  
  private lazy var walwalCell = WalWalEmitterCell(
    image: ResourceKitAsset.Sample.walwalEmitterDog.image,
    scale: 0.8,
    scaleRange: 0.5,
    lifetime: 2.0,
    lifetimeRange: 0.5,
    birthRate: 0,
    velocity: 800,
    velocityRange: 50,
    emissionRange: .pi * 2,
    spin: 3.14,
    spinRange: 6.28,
    alphaSpeed: -0.5
  )
  
  private lazy var walwalEmitter = WalWalEmitterLayer(
    cell: walwalCell,
    emitterShape: .sphere,
    emitterMode: .outline,
    renderMode: .additive
  )
  
  // MARK: - Properties
  
  private let gestureHandler = WalWalBoostGestureHandler()
  
  private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init(feedData: [WalWalFeedModel]) {
    super.init(frame: .zero)
    configureView()
    self.feedData.accept(feedData)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout()
  }
  
  // MARK: - Setup Methods
  
  private func configureView() {
    setupCollectionView()
    setupGestureHandler()
    setupBindings()
    setLayouts()
  }
  
  private func setupGestureHandler() {
    gestureHandler.delegate = self
    gestureHandler.setupLongPressGesture(for: collectionView)
  }
  
  private func setupCollectionView() {
    addSubview(collectionView)
  }
  
  private func setupBindings() {
    feedData
      .bind(to: collectionView.rx.items(cellIdentifier: "WalWalFeedCell", cellType: WalWalFeedCell.self)) { index, model, cell in
        cell.configureCell(feedData: model)
      }
      .disposed(by: disposeBag)
  }
  
  private func setLayouts() {
    flex.define { flex in
      flex.addItem(collectionView).grow(1)
    }
  }
  
  // MARK: - Boost Count Update
  
  private func updateBoostCount(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          var feedModel = feedData.value[safe: indexPath.item] else { return }
    feedModel.boostCount += walwalBoostGenerater.getCurrentCount()
    var updatedFeedData = feedData.value
    updatedFeedData[indexPath.item] = feedModel
    feedData.accept(updatedFeedData)
  }
}

// MARK: - GestureHandlerDelegate

extension WalWalFeed: GestureHandlerDelegate {
  func gestureHandlerDidBeginLongPress(_ gesture: UILongPressGestureRecognizer) {
    feedbackGenerator.prepare()
    walwalBoostGenerater.startBoostAnimation(for: gesture, in: collectionView)
  }
  
  func gestureHandlerDidEndLongPress(_ gesture: UILongPressGestureRecognizer) {
    walwalBoostGenerater.stopBoostAnimation()
    updateBoostCount(for: gesture)
  }
}

// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
