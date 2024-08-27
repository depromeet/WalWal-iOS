//
//  ProfileSettingTableViewCell.swift
//  MyPagePresenterImp
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout

final class ProfileSettingTableViewCell: UITableViewCell, ReusableView {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let titleLabel = CustomLabel(font: FontKR.H6.M).then {
    $0.font = FontKR.H6.M
    $0.textColor = AssetColor.gray700.color
  }
  private let subTitleLabel = CustomLabel(font: FontKR.Caption).then {
    $0.font = FontKR.Caption
    $0.textColor = AssetColor.gray500.color
  }
  private let rightLabel = CustomLabel(font: FontKR.B2).then {
    $0.font = FontKR.B2
    $0.textColor = AssetColor.gray600.color
    $0.textAlignment = .right
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setAttribute()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    resetCell()
  }
  
  private func setAttribute() {
    self.selectionStyle = .default
    contentView.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  private func setLayout() {
    contentView.addSubview(containerView)
    
    containerView.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .alignItems(.center)
      .define {
        $0.addItem(titleLabel)
          .marginLeft(30)
        
        $0.addItem()
          .direction(.row)
          .alignItems(.center)
          .define {
            $0.addItem(subTitleLabel)
              .marginRight(4)
            $0.addItem(rightLabel)
              .marginRight(19)
          }
      }
  }
  
  private func resetCell() {
    titleLabel.text = nil
    subTitleLabel.text = nil
    rightLabel.text = nil
  }
  
  func configureCell(
    title: String,
    subTitle: String,
    rightText: String
  ) {
    titleLabel.text = title
    titleLabel.flex.markDirty()
    
    subTitleLabel.text = subTitle.isEmpty ? " " : subTitle
    subTitleLabel.flex.markDirty()
    
    rightLabel.text = rightText.isEmpty ? " " : rightText
    rightLabel.flex.markDirty()
  }
}
