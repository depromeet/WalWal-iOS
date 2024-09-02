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

import Then
import FlexLayout
import PinLayout

final class FCMCollectionViewCell: UICollectionViewCell, ReusableView {
  private typealias Colors = ResourceKitAsset.Colors
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  
  private let iconImageView = UIImageView().then {
    $0.backgroundColor = Colors.gray150.color
    $0.contentMode = .scaleAspectFill
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
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
    
    iconImageView.layer.cornerRadius = iconImageView.frame.width/2
    iconImageView.clipsToBounds = true
  }
  
  private func configAttribute() {
    contentView.backgroundColor = Colors.gray100.color
    contentView.addSubview(rootContainer)
  }
  
  private func configLayout() {
    rootContainer.flex
      .direction(.row)
      .justifyContent(.start)
      .alignItems(.center)
      .marginHorizontal(20)
      .define {
        $0.addItem(iconImageView)
          .size(56)
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
    
    titleLabel.textColor = tintColor
    titleLabel.text = items.title
    messageLabel.text = items.message
    dateLabel.text = items.createdAt
    
    contentView.backgroundColor = backgroundColor
    
    layoutIfNeeded()
  }
  
  
}
