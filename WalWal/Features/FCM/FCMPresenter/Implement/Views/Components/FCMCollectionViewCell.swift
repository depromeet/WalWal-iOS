//
//  FCMCollectionViewCell.swift
//  FCMPresenterImp
//
//  Created by Jiyeon on 8/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit
import FCMDomain
import Utility

import Then
import FlexLayout
import PinLayout

final class FCMCollectionViewCell: UICollectionViewCell, ReusableView {
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  
  private let iconContainer = UIView().then {
    $0.backgroundColor = .clear
  }
  private let iconImageView = UIImageView().then {
    $0.backgroundColor = Colors.gray150.color
    $0.contentMode = .scaleAspectFill
  }
  private let boostBadge = UIImageView().then {
    $0.image = Images.boostNoti.image
    $0.backgroundColor = .clear
  }
  
  private let titleLabel = CustomLabel(font: FontKR.B2).then {
    $0.textColor = Colors.walwalOrange.color
  }
  
  private let messageLabel = CustomLabel(font: FontKR.B1).then {
    $0.textColor = Colors.black.color
  }
  private let dateLabel = CustomLabel(font: FontEN.Caption).then {
    $0.textColor = Colors.gray500.color
  }
  
  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configAttribute()
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
    boostBadge.isHidden = true
    titleLabel.text = nil
    messageLabel.text = nil
    dateLabel.text = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
    
    boostBadge.pin
      .bottomRight()
      .size(20.adjusted)
    iconImageView.pin
      .topLeft()
      .size(54.adjusted)
    
    iconImageView.layer.cornerRadius = iconImageView.frame.width/2
    iconImageView.clipsToBounds = true
  }
  
  private func configAttribute() {
    contentView.backgroundColor = Colors.gray100.color
    contentView.addSubview(rootContainer)
    [iconImageView, boostBadge].forEach {
      iconContainer.addSubview($0)
    }
  }
  
  private func configLayout() {
    rootContainer.flex
      .direction(.row)
      .justifyContent(.start)
      .alignItems(.center)
      .marginHorizontal(20)
      .define {
        $0.addItem(iconContainer)
          .size(56.adjusted)
        $0.addItem(contentContainer)
          .grow(1)
          .marginLeft(10)
      }
    
    contentContainer.flex
      .justifyContent(.start)
      .alignItems(.start)
      .define {
        $0.addItem()
          .direction(.row)
          .justifyContent(.spaceBetween)
          .width(100%)
          .define {
            $0.addItem(titleLabel)
            $0.addItem()
            $0.addItem(dateLabel)
          }
        $0.addItem(messageLabel)
          .marginTop(2)
      }
    
    
  }
  
  // MARK: - Methods
  
  public func configureCell(items: FCMItemModel) {
    let tintColor: UIColor = items.type == .mission ? Colors.walwalOrange.color : UIColor(hex: 0xFF6668)
    let backgroundColor: UIColor = items.isRead ? Colors.gray150.color : Colors.gray100.color
    let image = items.image ?? Images.missionNoti.image
    
    titleLabel.textColor = tintColor
    titleLabel.text = items.title
    messageLabel.text = items.message
    dateLabel.text = items.createdAt.formattedRelativeDate(
      format: .fullISO8601,
      to: .yearMonthDayDots
    )
    iconImageView.image = image
    boostBadge.isHidden = items.type == .mission
    contentView.backgroundColor = backgroundColor
    
    layoutIfNeeded()
  }
  
  
}
