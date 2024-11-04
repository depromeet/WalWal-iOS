//
//  MissionCompleteView.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 8/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import ResourceKit
import RecordsDomain

import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa


final class MissionCompleteView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily

  // MARK: - Property
  
  private var focusIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
  private let disposeBag = DisposeBag()
  private let missionRecordListRelay = BehaviorRelay<[RecordList]>(value: [])
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  
  private let missionCompletedLabel = CustomLabel(font: Fonts.KR.H7.B).then {
    $0.text = "📮 이번 달 함께한 추억이에요!"
    $0.textAlignment = .center
    $0.font = Const.completeLabelFont
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  
  private lazy var missionRecordCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: CarouselFlowLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.register(RecordCarouselCell.self)
    $0.isPagingEnabled = false
    $0.decelerationRate = .normal
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.clipsToBounds = true
    $0.contentInsetAdjustmentBehavior = .never
    $0.contentInset = Const.collectionViewContentInset
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureCollectionView()
    configureAttribute()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureCollectionView() {
    let customLayout = CarouselFlowLayout()
    missionRecordCollectionView.collectionViewLayout = customLayout
    
    missionRecordListRelay
      .asObservable()
      .bind(to: missionRecordCollectionView.rx.items(RecordCarouselCell.self)) { index, data, cell in
        cell.configureCell(record: data)
        
      }
      .disposed(by: disposeBag)
    
    missionRecordCollectionView.rx.itemSelected
      .bind(with: self) { owner , index in
        owner.missionRecordCollectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: true
        )
      }
      .disposed(by: disposeBag)
    
    focusIndex
      .asDriver()
      .drive(with: self) { owner, index in
        if owner.missionRecordListRelay.value.count > 0 {
          owner.missionRecordCollectionView.reloadItems(at: owner.missionRecordCollectionView.indexPathsForVisibleItems)
          owner.missionRecordCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func configureAttribute() {
    addSubview(rootContainer)
    
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configureLayout() {
    rootContainer.flex
      .width(100%)
      .define {
        $0.addItem(missionCompletedLabel)
          .marginTop(Const.topMargin)
          .marginHorizontal(24.adjusted)
          .marginBottom(0)
        $0.addItem(missionRecordCollectionView)
          .height(Const.containerHeight) // 그림자 보정, 상단 20 하단 20 여백
          .grow(1)
          .shrink(1)
      }
  }
  
  func configureCompleteView(recordList: [RecordList]) {
    missionRecordListRelay.accept(recordList)
    
    if !recordList.isEmpty {
      let lastIndex = IndexPath(item: recordList.count - 1, section: 0)
      focusIndex.accept(lastIndex) // 포커스를 마지막 아이템으로 설정
    }
  }
}

extension Reactive where Base: MissionCompleteView {
  var configureStartView: Binder<([RecordList])> {
    return Binder(base) { view, data in
      view.configureCompleteView(recordList: data)
    }
  }
}

final class CarouselFlowLayout: UICollectionViewFlowLayout {
  
  private var isInit: Bool = false
  private var previousOffset: CGFloat = 0
  private var currentPage: Int = 0
  
  override func prepare() {
    super.prepare()
    guard !isInit else { return }
    
    itemSize = Const.itemSize
    
    self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    scrollDirection = .horizontal
    
    minimumLineSpacing = Const.itemSpacing - (itemSize.width - itemSize.width * Const.spacingRatio)/2
    
    isInit = true
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let superAttributes = super.layoutAttributesForElements(in: rect)
    
    superAttributes?.forEach { attributes in
      guard let collectionView = self.collectionView else { return }
      
      let collectionViewCenter = collectionView.frame.size.width / 2
      let offsetX = collectionView.contentOffset.x
      let center = attributes.center.x - offsetX
      
      let maxDis = self.itemSize.width + self.minimumLineSpacing
      let dis = min(abs(collectionViewCenter-center), maxDis)
      
      let maxScale: CGFloat = 1.0
      let minScale: CGFloat = 216 / 255 // 여기는 동일하게 85%
      let ratio = (maxDis - dis)/maxDis
      let scale = ratio * (maxScale - minScale) + minScale
      
      attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    return superAttributes
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = collectionView else {
      return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
    
    let collectionViewCenterX = collectionView.bounds.size.width / 2
    let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewCenterX
    
    guard let attributesArray = self.layoutAttributesForElements(in: collectionView.bounds) else {
      return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
    
    var closestAttribute: UICollectionViewLayoutAttributes?
    var minDistance = CGFloat.greatestFiniteMagnitude
    
    for attributes in attributesArray {
      let itemCenterX = attributes.center.x
      let distance = abs(itemCenterX - proposedContentOffsetCenterX)
      
      if distance < minDistance {
        minDistance = distance
        closestAttribute = attributes
      }
    }
    
    guard let closest = closestAttribute else {
      return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
    
    let targetOffsetX = closest.center.x - collectionViewCenterX
    return CGPoint(x: targetOffsetX, y: proposedContentOffset.y)
  }
  
}
