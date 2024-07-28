//
//  ProfileSelectView.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import PinLayout
import FlexLayout

/// 프로필 이미지 선택 뷰
final class ProfileSelectView: UIView {
  
  private var profileSize: CGFloat
  private var viewWidth: CGFloat
  private var marginItems: CGFloat
  private var disposeBag = DisposeBag()
  private let profileItem = [
    ProfileCellModel(
      profileType: .defaultImage,
      curImage: UIImage(systemName: "star")
    ),
    ProfileCellModel(
      profileType: .selectImage,
      curImage: UIImage(systemName: "star")
    )
  ]
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
    $0.register(ProfileSelectCell.self)
    $0.showsHorizontalScrollIndicator = false
    $0.decelerationRate = .fast
    $0.contentInsetAdjustmentBehavior = .never
    let insetX = (viewWidth - profileSize) / 2.0
    $0.contentInset = UIEdgeInsets(
      top: 0,
      left: insetX,
      bottom: 0,
      right: insetX
    )
    $0.bounces = false
  }
  
  init(viewWidth: CGFloat, marginItems: CGFloat) {
    self.viewWidth = viewWidth
    profileSize = viewWidth / 2.2
    self.marginItems = marginItems
    super.init(frame: .zero)
    setLayout()
    bind()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setLayout() {
    self.addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .define {
        $0.addItem(collectionView)
          .alignItems(.center)
          .width(100%)
          .height(profileSize)
      }
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = marginItems
    layout.itemSize = CGSize(width: profileSize, height: profileSize)
    layout.scrollDirection = .horizontal
    return layout
  }
  
  private func bind() {
    Observable.just(profileItem)
      .bind(to: collectionView.rx.datasource(
        ProfileSelectCell.self
      )) { index, data, cell in
        cell.configCell(isActive: index == 0, data: data)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .bind(with: self) { owner , index in
        owner.collectionView.scrollToItem(
          at: index,
          at: .centeredHorizontally,
          animated: true
        )
      }
      .disposed(by: disposeBag)
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileSelectView: UICollectionViewDelegateFlowLayout {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let cellWidthIncludeSpacing = CGFloat(profileSize + marginItems)
    
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
    let roundedIndex: CGFloat = velocity.x > 0 ? ceil(index) : floor(index)
    offset = CGPoint(
      x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left,
      y: scrollView.contentInset.top
    )
    targetContentOffset.pointee = offset
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let centerX = scrollView.center.x + scrollView.contentOffset.x
    
    for cell in collectionView.visibleCells {
      let cellCenterX = cell.center.x
      let distanceFromCenter = abs(centerX - cellCenterX)
      let maxDistance = collectionView.bounds.width / 2
      let alpha = max(1 - distanceFromCenter / maxDistance, 0)
      if let cell = cell as? ProfileSelectCell {
        cell.setAlpha(alpha: alpha)
      }
    }
  }
}
