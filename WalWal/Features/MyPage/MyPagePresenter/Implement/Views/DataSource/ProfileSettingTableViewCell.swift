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
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel().then {
    $0.font = FontKR.H7.M
    $0.textColor = AssetColor.gray700.color
  }
  private let subTitleLabel = UILabel().then {
    $0.font = FontKR.Caption
    $0.textColor = AssetColor.gray500.color
  }
  private let rightLabel = UILabel().then {
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
    resetCell()
  }
  
  private func setAttribute() {
    self.selectionStyle = .default
    contentView.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  private func setLayout() {
    contentView.addSubview(containerView)
    [iconImageView, titleLabel, subTitleLabel, rightLabel].forEach {
      containerView.addSubview($0)
    }
    
    containerView.flex
      .direction(.row)
      .alignItems(.center)
      .define {
        $0.addItem(iconImageView)
          .size(22)
          .marginLeft(20)
        $0.addItem()
          .direction(.row)
          .alignItems(.center)
          .grow(1)
          .marginLeft(6)
          .define {
            $0.addItem(titleLabel)
              .minWidth(58)
            $0.addItem(subTitleLabel)
              .minWidth(21)
              .marginLeft(20)
          }
        $0.addItem(rightLabel)
          .minWidth(80)
          .marginRight(19)
          .alignSelf(.center)
      }
  }
  
  private func resetCell() {
    iconImageView.image = nil
    titleLabel.text = nil
    subTitleLabel.text = nil
    rightLabel.text = nil
  }
  
  func configureCell(
    iconImage: UIImage?,
    title: String,
    subTitle: String,
    rightText: String
  ) {
    iconImageView.image = iconImage
    titleLabel.text = title
    subTitleLabel.text = subTitle.isEmpty ? " " : subTitle
    rightLabel.text = rightText.isEmpty ? " " : rightText
    
    
  }
}
