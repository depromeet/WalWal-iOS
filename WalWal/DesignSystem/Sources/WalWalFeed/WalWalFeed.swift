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
  private typealias Fonts = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let walwalIndicator = WalWalRefreshControl(frame: .zero)
  private let containerView = UIView()
  public private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    
    let flowLayout = UICollectionViewFlowLayout()
    
    flowLayout.sectionInset = .init(top: 25.adjusted, left: 0, bottom: 20.adjusted, right: 0)
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
    $0.showsVerticalScrollIndicator = false
    $0.alwaysBounceVertical = true
  }
  
  // MARK: - Property
  
  public let profileTapped = PublishRelay<WalWalFeedModel>()
  
  public let menuButtonTapped = PublishRelay<Int>()
  
  public let commentButtonTapped = PublishRelay<(recordId: Int, writerNickname: String)>()
  
  public var feedData = BehaviorRelay<[WalWalFeedModel]>(value: [])
  
  public var updatedBoost = PublishRelay<(recordId: Int, count: Int)>()
  
  public var updatedComment = PublishRelay<(recordId: Int, count: Int)>()
  
  public let refreshLoading = PublishRelay<Bool>()
  
  public let scrollEndReached = PublishRelay<Bool>()
  
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
    
    self.collectionView.backgroundColor = isFeed ? Colors.gray150.color : Colors.gray100.color
    
    configureView()
    self.feedData.accept(feedData)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin
      .all()
    containerView.flex
      .layout()
    
    collectionView.collectionViewLayout.invalidateLayout()
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
        owner.currentFeedData = feedData
        owner.walwalIndicator.endRefreshing()
        owner.refreshLoading.accept(false)
      }
      .disposed(by: disposeBag)
    
    refreshLoading
      .distinctUntilChanged()
      .bind(to: walwalIndicator.rx.isRefreshing)
      .disposed(by: disposeBag)
    
    walwalIndicator.rx.controlEvent(.valueChanged)
      .withUnretained(self)
      .bind { owner, _ in
        owner.refreshLoading.accept(true)
        owner.currentFeedData.removeAll()
        owner.feedData.accept([])
        owner.collectionView.reloadData()
      }
      .disposed(by: disposeBag)
    
    walwalBoostGenerater.isOwnFeed
      .subscribe(with: self) { owner, isOwnFeed in
        if isOwnFeed {WalWalToast.shared.show(type: .error, message: "자신의 피드는 부스트할 수 없어요")}
      }
      .disposed(by: disposeBag)
    
    walwalBoostGenerater.boostFinished
      .withUnretained(self) { (owner, boostResult) in
        var updatedFeedData = owner.feedData.value
        var boostCount = boostResult.count
        
        if boostCount > 0 {
          if let feedModel = updatedFeedData[safe: boostResult.indexPath.item] {
            if boostResult.count > 500 {
              WalWalToast.shared.show(type: .boost, message: "부스터는 최대 500개까지만 가능해요!")
              boostCount = 500
            }
            
            var updatedModel = feedModel
            updatedModel.boostCount += boostCount
            updatedFeedData[boostResult.indexPath.item] = updatedModel
            
            owner.updatedBoost.accept(
              (recordId: updatedModel.recordId,
               count: boostCount)
            )
          }
        }
        
        return updatedFeedData
      }
      .bind(to: feedData)
      .disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .distinctUntilChanged()
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .map(isNearBottom)
      .filter{ $0 }
      .bind(to: scrollEndReached )
      .disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .map { $0.y < -59 }
      .map { !$0 }
      .bind(to: walwalIndicator.indicatorIsHidden)
      .disposed(by: disposeBag)

    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  private func setLayouts() {
    addSubview(containerView)
    
    containerView.flex.define {
      $0.addItem(collectionView)
        .grow(1)
    }
  }
  
  /// 피드 데이터 불러온 후 추가
  public func addNewData(_ newData: [WalWalFeedModel]) {
    let currentDataCount = currentFeedData.count
    currentFeedData.append(contentsOf: newData)
    feedData.accept(currentFeedData)
    let newIndexPaths = (currentDataCount..<currentDataCount + newData.count).map { IndexPath(item: $0, section: 0) }
    
    collectionView.performBatchUpdates({
      collectionView.insertItems(at: newIndexPaths)
    }, completion: nil)
  }
  
  /// 특정 피드만 업데이트
  public func updateRecord(at recordId: Int, updatedFeed: WalWalFeedModel) {
    if let index = currentFeedData.firstIndex(where: { $0.recordId == recordId }) {
      currentFeedData[index] = updatedFeed
      feedData.accept(currentFeedData)
      
      collectionView.performBatchUpdates({
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
      }, completion: nil)
      
      collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  /// 특정 피드만 업데이트
  public func updateCommentCount(at recordId: Int, commentCount: Int) {
    if let index = currentFeedData.firstIndex(where: { $0.recordId == recordId }) {
      currentFeedData[index].commentCount = commentCount
      feedData.accept(currentFeedData)
      
      UIView.performWithoutAnimation {
          collectionView.performBatchUpdates({
              collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
          }, completion: nil)
      }

      collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  
  /// 특정 레코드로 이동하는 메서드
  public func scrollToRecord(withId recordId: Int, animated: Bool = true) {
    if let index = currentFeedData.firstIndex(where: { $0.recordId == recordId }) {
      let indexPath = IndexPath(item: index, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
    }
  }
  
  
  // MARK: - Boost Count Update
  
  private func updateBoostCount(for gesture: UILongPressGestureRecognizer) {
    let point = gesture.location(in: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point),
          let feedModel = feedData.value[safe: indexPath.item] else { return }
    var updatedFeedData = feedData.value
    var updatedRecord = updatedFeedData[indexPath.item]
    updatedRecord = feedModel
    
    updatedFeedData[indexPath.item] = updatedRecord
    feedData.accept(updatedFeedData)
    
    collectionView.performBatchUpdates({
      collectionView.reloadItems(at: [indexPath])
    }, completion: nil)
    
    collectionView.collectionViewLayout.invalidateLayout()
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
    // 프로필 영역 터치
    cell.feedView.profileTapped
      .bind(with: self) { owner, data in
        owner.profileTapped.accept(data)
      }
      .disposed(by: cell.disposeBag)
    // 메뉴 버튼 클릭
    cell.feedView.menuButtonTapped
      .bind(to: menuButtonTapped)
      .disposed(by: cell.disposeBag)
    // 댓글 영역 터치
    cell.feedView.commentButtonTapped
      .bind(to: commentButtonTapped)
      .disposed(by: cell.disposeBag)
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
      let width = collectionView.bounds.width - 32.adjustedWidth
      let model = currentFeedData[indexPath.row]
      let cell = collectionView.cellForItem(at: indexPath) as? WalWalFeedCell
      let isExpanded = cell?.feedView.isExpanded ?? false
      
      let content = model.contents
      
      let baseHeight: CGFloat = 516.adjustedWidth
      let numberOfLine = content.lineNumber(
        forWidth: width - 40,
        font: Fonts.B3
      )
      let lineCount = isExpanded ? numberOfLine : max(1,min(2, numberOfLine))
      let lineHeight = (17 * (lineCount - 1)).adjusted
      let height: CGFloat =  baseHeight + lineHeight
      
      return CGSize(width: width, height: height)
    }
}


// MARK: - Array Extension

extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
