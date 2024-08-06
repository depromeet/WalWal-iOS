//
//  DescriptionView.swift
//  OnboardingPresenterView
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout

/// 온보딩 첫 화면 스크롤뷰에서 사용하기위한 뷰
final class DescriptionView: UIView {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let mainTitleLabel = UILabel().then {
    $0.font = Font.H3
    $0.textColor = Color.black.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let subTextLabel = UILabel().then {
    $0.font = Font.B1
    $0.textColor = Color.gray600.color
    $0.textAlignment = .center
  }
  private let imageView = UIImageView().then {
    $0.backgroundColor = Color.walwalBeige.color
  }
  
  // MARK: - Initialize
  
  init(mainTitle: String, subText: String, image: UIImage?) {
    super.init(frame: .zero)
    mainTitleLabel.text = mainTitle
    subTextLabel.text = subText
    if let image = image {
      imageView.image = image
    }
    setAttributes()
    setLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  private func setAttributes() {
    addSubview(containerView)
  }
  
  private func setLayout() {
    containerView.flex
      .justifyContent(.center)
      .define { flex in
        flex.addItem(mainTitleLabel)
        flex.addItem(subTextLabel)
          .marginTop(10)
        flex.addItem(imageView)
          .alignSelf(.center)
          .marginTop(50)
          .size(220.adjustedWidth)
      }
  }
}
