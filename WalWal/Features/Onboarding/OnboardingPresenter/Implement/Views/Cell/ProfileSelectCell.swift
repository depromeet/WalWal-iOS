//
//  ProfileSelectCell.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import Utility

import FlexLayout
import PinLayout
import Then

final class ProfileSelectCell: UICollectionViewCell, ReusableView {
  
  // MARK: - UI
  
  private let borderView = UIView().then {
    $0.backgroundColor = .clear
    $0.layer.borderColor = ResourceKitAsset.Colors.walwalOrange.color.cgColor
    $0.layer.borderWidth = 3
  }
  let changeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "repeat"), for: .normal)
    $0.tintColor = .white
    $0.backgroundColor = ResourceKitAsset.Colors.walwalOrange.color
  }
  private let profileImageView = UIImageView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.walwalBeige.color
    $0.tintColor = .gray
  }
  private let inActiveimageView = UIImageView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.gray300.color
    $0.tintColor = .gray
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
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    [profileImageView, inActiveimageView, borderView, changeButton].forEach {
      $0.layer.cornerRadius = $0.frame.width/2
    }
    changeButtonLayout()
    contentView.flex.layout(mode: .fitContainer)
  }
  
  
  private func setAttribute() {
    contentView.addSubview(inActiveimageView)
    contentView.addSubview(profileImageView)
    profileImageView.addSubview(borderView)
    borderView.addSubview(changeButton)
  }
  
  private func setLayout() {
    inActiveimageView.pin
      .center()
      .size(140)
    profileImageView.pin
      .center()
      .size(157)
    borderView.pin
      .center()
      .size(168)
    changeButton.pin
      .width(40)
      .height(40)
  }
  
  private func changeButtonLayout() {
    let radius = borderView.frame.size.width / 2
    let angle = CGFloat.pi / 4 // 45도 각도, 원하는 각도로 설정
    let xOffset = radius * cos(angle)
    let yOffset = radius * sin(angle)
    changeButton.pin
      .vCenter(xOffset)
      .hCenter(yOffset)
  }
  
  func configCell(isActive: Bool, data: ProfileCellModel) {
    profileImageView.image = data.curImage
    print(data.profileType)
    if isActive {
      inActiveimageView.isHidden = true
    } else {
      profileImageView.isHidden = true
    }
  }
  
  /// 스와이프 시 비활성화 이미지 뷰와 프로필 뷰의 자연스러운 전환 위한 alpha값 조정 메서드
  func setAlpha(alpha: CGFloat) {
    if alpha < 0.2 {
      profileImageView.isHidden = true
      inActiveimageView.alpha = 1
    } else if alpha > 0.8 {
      inActiveimageView.isHidden = true
      profileImageView.alpha = 1
    } else {
      profileImageView.isHidden = false
      inActiveimageView.isHidden = false
      profileImageView.alpha = alpha
      inActiveimageView.alpha = 1-alpha
    }
  }
  
}
