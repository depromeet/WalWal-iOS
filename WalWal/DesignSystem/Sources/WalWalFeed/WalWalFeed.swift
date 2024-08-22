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
  let refreshLoading = PublishRelay<Bool>()
  public let scrollEndReached = PublishRelay<Bool>()
  
  
  // MARK: - UI
  
  public private(set) var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 14
    
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
    $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 24, right: 0)
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
    self.headerHeight = isFeed ? 71 : 0
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
    collectionView.collectionViewLayout = createLayout()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    walwalIndicator.endRefreshing()
    collectionView.refreshControl = walwalIndicator
  }
  
  private func createLayout() -> UICollectionViewLayout{
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .estimated(504))
    let itme = NSCollectionLayoutItem(layoutSize: itemSize)
    // estimated를 사용하게 되면 contentInsets 값은 무시가 됩니다.
    itme.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(20), trailing: nil, bottom: nil)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .estimated(504))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [itme])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

    let section = NSCollectionLayoutSection(group: group)
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
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
          // 여기에 데이터 로드 완료 시 호출할 로직 추가
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
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: headerHeight)
  }
}

// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
