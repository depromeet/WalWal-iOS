//
//  DescriptionView.swift
//  OnboardingPresenterView
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

/// 온보딩 첫 화면 스크롤뷰에서 사용하기위한 뷰
final class DescriptionView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let mainTitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .black
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  private let subTextLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .lightGray
    $0.textAlignment = .center
  }
  private let imageView = UIImageView().then {
    $0.backgroundColor = .systemOrange
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
          .size(220)
      }
    
  }
  
}
