//
//  DescriptionCell.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import RxSwift
import FlexLayout
import PinLayout
import Then

struct DescriptionModel: Hashable {
  var title: String
  var subTitle: String
  var image: UIImage
}

final class DescriptionCell: UICollectionViewCell, ReusableView {
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let mainTitleLabel = CustomLabel(font: Font.H3).then {
    $0.textColor = Color.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let subTextLabel = CustomLabel(font: Font.B1).then {
    $0.textColor = Color.gray600.color
    $0.textAlignment = .center
  }
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
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
    mainTitleLabel.text = ""
    subTextLabel.text = ""
    imageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.pin.all()
    contentView.flex
      .layout(mode: .adjustHeight)
  }
  
  private func configAttribute() {
    [mainTitleLabel, subTextLabel, imageView].forEach {
      contentView.addSubview($0)
    }
  }
  
  private func configLayout() {
    contentView.flex
      .justifyContent(.center)
      .define {
        $0.addItem(mainTitleLabel)
          .height(100%)
        $0.addItem(subTextLabel)
          .height(100%)
          .marginTop(4.adjustedHeight)
        $0.addItem(imageView)
          .alignSelf(.center)
          .width(100%)
          .marginTop(8)
          .aspectRatio(375.adjustedWidth/280.adjustedHeight)
      }
  }
  
  // MARK: - Method
  
  func configData(data: DescriptionModel) {
    mainTitleLabel.text = data.title
    subTextLabel.text = data.subTitle
    imageView.image = data.image
    layoutIfNeeded()
  }
  
}
