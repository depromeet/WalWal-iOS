//
//  FCMCollectionViewHeader.swift
//  FCMPresenterImp
//
//  Created by Jiyeon on 9/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import FlexLayout
import PinLayout
import Then

final class FCMCollectionViewHeader: UICollectionReusableView, ReusableView {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontKR = ResourceKitFontFamily.KR
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  private let separator1 = UIView().then {
    $0.backgroundColor = Colors.gray200.color
  }
  private let titleLabel = UILabel().then {
    $0.font = FontKR.B2
    $0.textColor = Colors.gray400.color
    $0.text = "이전 알림"
  }
  private let separator2 = UIView().then {
    $0.backgroundColor = Colors.gray200.color
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configAttribute()
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configAttribute() {
    addSubview(rootContainer)
  }
  
  private func configLayout() {
    rootContainer.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .marginHorizontal(20)
      .define {
        $0.addItem(separator1)
          .height(1)
          .grow(1)
        $0.addItem(titleLabel)
          .marginHorizontal(13.adjustedWidth)
        $0.addItem(separator2)
          .height(1)
          .grow(1)
      }
  }
}
