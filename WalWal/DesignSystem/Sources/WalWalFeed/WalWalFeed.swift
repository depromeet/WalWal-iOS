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
import Then
import RxSwift
import RxCocoa
import Lottie

public final class WalWalFeed: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  let walwalIndicator = WalWalLoadingIndicator(frame: .zero)
  public let refreshLoading = PublishRelay<Bool>()
  public let scrollEndReached = PublishRelay<Bool>()
  
  
  // MARK: - UI
  
  public private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    flowLayout.sectionInset = .init(top: 20.adjusted, left: 0, bottom: 20.adjusted, right: 0)
    flowLayout.minimumLineSpacing = 14.adjusted
    flowLayout.headerReferenceSize = .init(width: 0, height: headerHeight)
    $0.collectionViewLayout = flowLayout
    $0.backgroundColor = .clear
    $0.register(
      WalWalFeedCell.self,
      forCellWithReuseIdentifier: WalWalFeedCell.identifier
    )
    $0.register(
      FeedHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: FeedHeaderView.identifier
    )
    $0.showsHorizontalScrollIndicator = false
    $0.alwaysBounceVertical = true
  }
  
  // MARK: - Property
  
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  private var headerHeight: CGFloat = 0
  
  private var currentFeedData: [WalWalFeedModel] = []
  
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
  
  private lazy var walwalCell = WalWalEmitterCell()
  
  private lazy var walwalEmitter = WalWalEmitterLayer(cell: walwalCell)
  
  // MARK: - Properties
  
  private let gestureHandler: WalWalBoostGestureHandler?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  public init(
    feedData: [WalWalFeedModel],
    isFeed: Bool = true
  ) {
    self.gestureHandler = isFeed ? WalWalBoostGestureHandler() : nil
    self.headerHeight = isFeed ? 71.adjusted : 0
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
    gestureHandler?.delegate = self
    gestureHandler?.setupLongPressGesture(for: collectionView)
  }
  
  private func setupCollectionView() {
    collectionView.dataSource = self
    
    walwalIndicator.endRefreshing()
    collectionView.refreshControl = walwalIndicator
  }
  
  private func setupBindings() {
    feedData
      .asDriver(onErrorJustReturn: [])
      .drive(with: self) { owner, feedData in
        self.currentFeedData = feedData
        owner.collectionView.reloadData()
        owner.walwalIndicator.endRefreshing()
      }
      .disposed(by: disposeBag)
    
    refreshLoading
      .distinctUntilChanged()
      .bind(to: walwalIndicator.rx.isRefreshing)
      .disposed(by: disposeBag)
    
    walwalIndicator.rx.controlEvent(.valueChanged)
      .bind { [weak self] _ in
        self?.refreshLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
          self?.feedData.accept(self?.feedData.value ?? [])
          self?.refreshLoading.accept(false)
        }
      }
      .disposed(by: disposeBag)
    
    walwalBoostGenerater.boostFinished
      .withLatestFrom(feedData) { (boostResult, currentFeedData) -> [WalWalFeedModel] in
        var updatedFeedData = currentFeedData
        if let feedModel = updatedFeedData[safe: boostResult.indexPath.item] {
          var updatedModel = feedModel
          updatedModel.boostCount += boostResult.count
          updatedFeedData[boostResult.indexPath.item] = updatedModel
        }
        return updatedFeedData
      }
      .bind(to: feedData)
      .disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .distinctUntilChanged()
      .map(isNearBottom)
      .filter{ $0 }
      .bind(to: scrollEndReached )
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  private func setLayouts() {
    flex.define {
      $0.addItem(collectionView)
        .grow(1)
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
  
  // MARK: - Scroll
  private func isNearBottom(_: CGPoint) -> Bool {
    return collectionView.isNearBottom()
  }
}

// MARK: - GestureHandlerDelegate

extension WalWalFeed: GestureHandlerDelegate {
  func gestureHandlerDidBeginLongPress(_ gesture: UILongPressGestureRecognizer) {
    walwalBoostGenerater.isEndedLongPress = false
    walwalBoostGenerater.startBoostAnimation(for: gesture, in: collectionView)
  }
  
  func gestureHandlerDidEndLongPress(_ gesture: UILongPressGestureRecognizer) {
    walwalBoostGenerater.isEndedLongPress = true
    walwalBoostGenerater.stopBoostAnimation()
    updateBoostCount(for: gesture)
  }
}

// MARK: - UICollectionViewDataSource

extension WalWalFeed: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentFeedData.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalWalFeedCell.identifier, for: indexPath) as! WalWalFeedCell
    let model = currentFeedData[indexPath.row]
    cell.configureCell(feedData: model)
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedHeaderView.identifier, for: indexPath) as! FeedHeaderView
      return header
    }
    return UICollectionReusableView()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WalWalFeed: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - 40
    let content = feedData.value[indexPath.row].contents
    
    let lineHeight: Int = content.count / 40
    let lineBreakCount = content.filter { $0 == "\n" }.count
    let totalLineCount = min(3, lineHeight + lineBreakCount)
    
    let height: CGFloat = CGFloat(480 + (16 * totalLineCount))
    
    return CGSize(width: width, height: height)
  }
}


// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
