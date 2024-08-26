//
//  WalWalProfile.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

public enum PetType: String {
  case dog = "DOG"
  case cat = "CAT"
}

/// 프로필 이미지 선택 뷰
///
/// - Parameters:
///   - type: 동물 타입 (.dog or .cat)
public final class WalWalProfile: UIView {
  private typealias Images = ResourceKitAsset.Assets
  
  /// ViewController에게 PHPickerView presnest 요청하기 위한 이벤트
  ///
  /// 사용 예시:
  /// ```swift
  /// profileView.showPHPicker
  ///   .bind(with: self) { owner, _ in
  ///    PHPickerManager.shared.presentPicker(vc: owner)
  ///   }
  ///   .disposed(by: disposeBag)
  public let showPHPicker = PublishRelay<Void>()
  
  /// 현재 포커스되어있는 셀의 이미지 데이터
  public var curProfileItems = PublishRelay<WalWalProfileModel>()
  /// PHPickerView에서 선택한 이미지를 전달받기 위한 이벤트
  public var selectedImageData = PublishRelay<UIImage>()
  /// 이미지 컬렉션 뷰 디폴트 포커스 위치 설정
  private var focusIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
  private let changeSelectImage = PublishRelay<WalWalProfileCell>()
  private var defaultImages: [DefaultProfile]
  private var defaultImageIndex: Int = 0
  private var defaultImageCount: Int
  private var userSelectImage: UIImage? = nil
  
  private lazy var profileItem: [WalWalProfileModel] = [
    WalWalProfileModel(
      profileType: .defaultImage,
      defaultImage: defaultImages[defaultImageIndex]
    ),
    WalWalProfileModel(
      profileType: .selectImage,
      selectImage: userSelectImage
    )
  ]
  private var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  private let profileSize: CGFloat = 170.adjusted
  private let viewWidth: CGFloat = UIScreen.main.bounds.width
  private let marginItems: CGFloat
  private let inActiveProfileSize: CGFloat = 140.adjusted
  
  private let rootContainer = UIView()
  lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
    $0.backgroundColor = .clear
    $0.register(WalWalProfileCell.self)
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
  
  // MARK: - Initialize
  
  /// - Parameters:
  ///   - type: 반려동물 타입
  ///   - defaultImage: 기본 이미지 이름
  ///   - userImage: 사용자 선택 이미지 설정
  public init(
    type: PetType,
    defaultImage: String? = nil,
    userImage: UIImage? = nil
  ) {
    defaultImages = type == .dog ? DefaultProfile.defaultDogs : DefaultProfile.defaultCats
    if let defaultImage = defaultImage, let defaultType = DefaultProfile(rawValue: defaultImage) {
      self.defaultImageIndex = defaultImages.firstIndex(of: defaultType) ?? 0
    } else {
      self.defaultImageIndex = 0
    }
    defaultImageCount = defaultImages.count
    marginItems = (viewWidth - profileSize*2)/2
    if let userImage = userImage {
      self.userSelectImage = userImage
    }
    
    super.init(frame: .zero)
    setLayout()
    bind()
    focusIndex.accept(IndexPath(item: userImage != nil ? 1 : 0, section: 0))
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
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
      .bind(to: collectionView.rx.items(WalWalProfileCell.self)) { index, data, cell in
        
        cell.configInitialCell(isActive: index==0, data: data)
        cell.changeButton.rx.tap
          .asDriver()
          .drive(with: self) { owner, _ in
            if data.profileType == .defaultImage {
              let nxtIndex = (owner.defaultImageIndex+1) % owner.defaultImages.count
              owner.defaultImageIndex = nxtIndex
              owner.profileItem[index].defaultImage = owner.defaultImages[nxtIndex]
              cell.changeProfileImage(owner.defaultImages[nxtIndex].image)
              owner.curProfileItems.accept(owner.profileItem[index])
            } else {
              owner.showPHPicker.accept(())
              owner.changeSelectImage.accept(cell)
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
    Observable.combineLatest(changeSelectImage, selectedImageData)
      .map {
        return ($0, $1)
      }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, result in
        let (cell, photo) = result
        cell.changeProfileImage(photo)
        owner.profileItem[1].selectImage = photo
        owner.curProfileItems.accept(owner.profileItem[1])
      }
      .disposed(by: disposeBag)
    
    focusIndex
      .asDriver()
      .drive(with: self) { owner, index in
        DispatchQueue.main.async {
          owner.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WalWalProfile: UICollectionViewDelegateFlowLayout {
  public func scrollViewWillEndDragging(
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
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrolledOffset = scrollView.contentOffset.x + scrollView.contentInset.left
    let cellWidth = profileSize + marginItems
    let index = Int(round(scrolledOffset / cellWidth))
    let centerX = scrollView.center.x + scrollView.contentOffset.x
    if index >= 0 {
      curProfileItems.accept(profileItem[index])
    }
    
    
    for cell in collectionView.visibleCells {
      let cellCenterX = cell.center.x
      let distanceFromCenter = abs(centerX - cellCenterX)
      let maxDistance = (inActiveProfileSize + profileSize)/2 + marginItems
      
      let alpha = max(1 - distanceFromCenter / maxDistance, 0)
      if let cell = cell as? WalWalProfileCell {
        cell.setAlpha(alpha: alpha)
      }
    }
  }
}
