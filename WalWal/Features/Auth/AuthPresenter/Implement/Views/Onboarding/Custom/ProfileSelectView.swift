//
//  ProfileSelectView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import ResourceKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

/// 프로필 이미지 선택 뷰
final class ProfileSelectView: UIView {
  
  /// ViewController에게 PHPickerView presnest 요청하기 위한 이벤트
  ///
  /// 사용 예시:
  /// ```swift
  /// profileView.showPHPicker
  ///   .bind(with: self) { owner, _ in
  ///    PHPickerManager.shared.presentPicker(vc: owner)
  ///   }
  ///   .disposed(by: disposeBag)
  let showPHPicker = PublishRelay<Void>()
  
  /// 현재 포커스되어있는 셀의 이미지 데이터
  ///
  /// 완료 버튼 터치 시 포커스되어있는 프로필 이미지 정보 가져옴
  var focusProfileItem: ProfileCellModel {
    return profileItem[focusIndex]
  }
  /// 현재 포커스 셀 인덱스
  private var focusIndex: Int = 0
  private let changeSelectImage = PublishRelay<ProfileSelectCell>()
  private var profileItem = [
    ProfileCellModel(
      profileType: .defaultImage,
      curImage: UIImage(systemName: "star") // TODO: - 기본 이미지 설정
    ),
    ProfileCellModel(
      profileType: .selectImage,
      curImage: UIImage(systemName: "star") // TODO: - 기본 이미지 설정
    )
  ]
  private var disposeBag = DisposeBag()
  // MARK: - UI
  
  private let profileSize: CGFloat = 170.adjusted
  private let viewWidth: CGFloat = UIScreen.main.bounds.width
  private let marginItems: CGFloat = 17.adjusted
  
  private let rootContainer = UIView()
  lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color
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
  
  init() {
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
      .bind(to: collectionView.rx.items(ProfileSelectCell.self)) { index, data, cell in
        cell.configInitialCell(isActive: index==0, data: data)
        cell.changeButton.rx.tap
          .asDriver()
          .drive(with: self) { owner, _ in
            if data.profileType == .defaultImage {
              cell.changeProfileImage(.defaultImage)
            } else {
              owner.showPHPicker.accept(())
              owner.changeSelectImage.accept((cell))
            }
            
          }
          .disposed(by: cell.disposeBag)
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
    
    /// 유저 앨범 이미지
    Observable.combineLatest(changeSelectImage, PHPickerManager.shared.selectedPhoto)
      .map {
        return ($0, $1)
      }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, result in
        let (cell, photo) = result
        cell.changeProfileImage(.selectImage, image: photo)
        owner.profileItem[1].curImage = photo
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
    let scrolledOffset = scrollView.contentOffset.x + scrollView.contentInset.left
    let cellWidth = profileSize + marginItems
    let index = Int(round(scrolledOffset / cellWidth))
    focusIndex = index
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