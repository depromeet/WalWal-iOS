//
//  WalWalProfileCell.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import FlexLayout
import PinLayout
import Then

final class WalWalProfileCell: UICollectionViewCell, ReusableView {
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  private typealias Image = ResourceKitAsset.Images
  private typealias Assets = ResourceKitAsset.Assets
  
  var disposeBag = DisposeBag()
  
  private var defaultIndex: Int = 0
  
  // MARK: - UI
  
  private let borderView = UIView().then {
    $0.backgroundColor = .clear
    $0.layer.borderColor = Color.walwalOrange.color.cgColor
    $0.layer.borderWidth = 3
  }
  let changeButton = UIButton().then {
    $0.tintColor = Color.white.color
    $0.backgroundColor = Color.walwalOrange.color
  }
  private let profileImageView = UIImageView().then {
    $0.backgroundColor = Color.white.color
    $0.contentMode = .scaleAspectFill
  }
  private let inActiveimageView = UIImageView().then {
    $0.image = Assets.inactiveImage.image
  }
  
  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttribute()
    setLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    [profileImageView, inActiveimageView, borderView, changeButton].forEach {
      $0.layer.cornerRadius = $0.frame.width/2
      $0.clipsToBounds = true
    }
    changeButtonLayout()
    contentView.flex
      .layout(mode: .adjustHeight)
  }
  
  
  private func setAttribute() {
    [inActiveimageView, borderView, changeButton].forEach {
      contentView.addSubview($0)
    }
    borderView.addSubview(profileImageView)
  }
  
  private func setLayout() {
    inActiveimageView.pin
      .center()
      .size(140.adjusted)
    borderView.pin
      .center()
      .size(173.adjusted)
    profileImageView.pin
      .center()
      .size(160.adjusted)
    changeButton.pin
      .size(40.adjusted)
  }
  
  private func changeButtonLayout() {
    let radius = borderView.frame.size.width / 2
    let angle = CGFloat.pi / 4.1 // 45도 각도
    let xOffset = radius * cos(angle)
    let yOffset = radius * sin(angle) - 1
    changeButton.pin
      .vCenter(xOffset)
      .hCenter(yOffset)
  }
  
  /// 셀 초기 설정 메서드
  ///
  /// - Parameters:
  ///   - isActive: 현재 활성화 여부(가운데에 위치하는 셀인지)
  ///   - data: 셀 데이터
  func configInitialCell(isActive: Bool, data: WalWalProfileModel) {
    
    if data.profileType == .defaultImage {
      if let defaultImage = data.defaultImage {
        profileImageView.image = defaultImage.image
        inActiveimageView.image = Assets.inactiveDefault.image
      }
      let changeImage = Image.swapL.image
      changeButton.setImage(changeImage, for: .normal)
    } else {
      profileImageView.image = data.selectImage ?? Assets.activeImage.image
      changeButton.setImage(Image.editL.image, for: .normal)
    }
    if isActive {
      inActiveimageView.isHidden = true
    } else {
      profileImageView.isHidden = true
      borderView.isHidden = true
      changeButton.isHidden = true
    }
  }
  
  /// 스와이프 시 비활성화 이미지 뷰와 프로필 뷰의 자연스러운 전환 위한 alpha값 조정 메서드
  func setAlpha(alpha: CGFloat) {
    let hiddenImageLevel: CGFloat = 0.05
    let shownImageLevel: CGFloat = 0.99
    profileImageView.isHidden = alpha < hiddenImageLevel
    borderView.isHidden = alpha < hiddenImageLevel
    changeButton.isHidden = alpha < hiddenImageLevel
    inActiveimageView.isHidden = alpha > shownImageLevel
    
    if !profileImageView.isHidden {
      profileImageView.alpha = alpha
      borderView.alpha = alpha
      changeButton.alpha = alpha
    }
    if !inActiveimageView.isHidden {
      inActiveimageView.alpha = 1 - alpha
    }
  }
  
  /// 프로필 이미지 변경 위한 메서드
  ///
  /// 사용 예시
  /// - `cell.changeProfileImage(profileImage)`
  ///
  /// - Parameters:
  ///   - image: 프로필 이미지
  func changeProfileImage(_ image: UIImage?) {
    profileImageView.image = image
  }
}
