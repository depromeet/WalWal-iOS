//
//  PetView.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout

/// 반려동물 타입을 구분하기 위한 enum
enum PetType: String {
  case dog = "강아지"
  case cat = "고양이"
  
  /// 회원가입 시 사용할 반려동물 종류 프로퍼티
  var type: String {
    switch self {
    case .dog:
      return "DOG"
    case .cat:
      return "CAT"
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
  private let inActiveView = UIView().then {
    $0.backgroundColor = Color.gray200.color
    
  }
  private let petImage = UIImageView().then {
    $0.image = Images.initialProfile.image
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
  }
  private let typeLabel = UILabel().then {
    $0.textColor = Color.gray900.color
    $0.font = Font.H6.M
  }
  
  // MARK: - Initialize
  
  init(petType: PetType) {
    super.init(frame: .zero)
    self.petType = petType
    typeLabel.text = petType.rawValue
    addSubview(containerView)
    petView.addSubview(petImage)
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
          .size(158)
        flex.addItem(typeLabel)
          .marginTop(20)
      }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    petImage.pin
      .center()
      .size(80%)
    containerView.flex
      .layout(mode: .adjustHeight)
    
    petView.layer.cornerRadius = petView.frame.width/2
    petView.layer.borderColor = Color.gray200.color.cgColor
    petView.layer.borderWidth = 1
  }
  
  // TODO: 디자인 확정시 변경 스타일 변경 필요
  
  /// 반려동물 선택 여부에 따른 스타일 변경
  /// - Parameters:
  ///   - isSelected: 선택 여부
  private func petSelectedStyle(isSelected: Bool) {
    if isSelected {
      petView.backgroundColor = Color.yellow.color
      petView.tintColor = Color.black.color
      typeLabel.textColor = Color.gray900.color
    } else {
      petView.backgroundColor = Color.white.color
//      petView.tintColor = Color.gray300.color
      petImage.image?.withTintColor(Color.gray300.color)
      typeLabel.textColor = Color.gray300.color
    }
  }
}
