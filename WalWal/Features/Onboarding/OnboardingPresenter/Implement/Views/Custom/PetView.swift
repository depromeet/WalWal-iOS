//
//  PetView.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import DesignSystem

import FlexLayout
import PinLayout

/// 반려동물 타입을 구분하기 위한 enum
extension PetType {
  var title: String {
    switch self {
    case .dog:
      return "강아지"
    case .cat:
      return "고양이"
    }
  }
  
  var image: UIImage {
    switch self {
    case .dog:
      return ResourceKitAsset.Assets.dogIcon.image
    case .cat:
      return ResourceKitAsset.Assets.catIcon.image
    }
  }
}

/// 반려동물 타입을 보여주기 위한 뷰
/// - Parameters:
///   - petType: 해당 뷰의 반려동물 타입
final class PetView: UIView {
  
  // MARK: - Properties
  
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  private typealias Images = ResourceKitAsset.Sample
  
  /// 반려동물 타입 선택 여부에 따라 스타일 변경하기 위한 프로퍼티
  var isSelected: Bool = false {
    didSet {
      petSelectedStyle(isSelected: isSelected)
    }
  }
  private var petType: PetType = .dog
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let petView = UIView().then {
    $0.backgroundColor = Color.white.color
    $0.clipsToBounds = true
  }
  private let petImage = UIImageView().then {
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
  }
  private let typeLabel = CustomLabel(font: Font.H6.M).then {
    $0.textColor = Color.gray700.color
  }
  
  // MARK: - Initialize
  
  init(petType: PetType) {
    super.init(frame: .zero)
    self.petType = petType
    typeLabel.text = petType.title
    petImage.image = petType.image
    addSubview(containerView)
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  private func setLayout() {
    containerView.flex
      .alignItems(.center)
      .define { flex in
        flex.addItem(petView)
          .size(162.adjustedWidth)
        flex.addItem(typeLabel)
          .marginTop(16.adjustedHeight)
      }
    
    petView.flex
      .define {
        $0.addItem(petImage)
          .size(149.adjusted)
          .marginTop(8.adjustedHeight)
          .marginBottom(5.adjustedHeight)
          .marginRight(6.adjustedWidth)
          .marginLeft(7.adjustedWidth)
      }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    containerView.flex
      .layout(mode: .adjustHeight)
    
    petView.layer.cornerRadius = petView.frame.width/2
    petView.layer.borderColor = Color.gray200.color.cgColor
    petView.layer.borderWidth = 1
  }
  
  /// 반려동물 선택 여부에 따른 스타일 변경
  /// - Parameters:
  ///   - isSelected: 선택 여부
  private func petSelectedStyle(isSelected: Bool) {
    if isSelected {
      petView.backgroundColor = Color.yellow.color
      typeLabel.textColor = Color.gray700.color
    } else {
      petView.backgroundColor = Color.white.color
      typeLabel.textColor = Color.gray400.color
    }
  }
}
