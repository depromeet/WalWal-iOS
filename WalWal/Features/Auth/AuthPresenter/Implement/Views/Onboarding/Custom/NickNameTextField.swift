//
//  NicknameTextField.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import Then

final class NicknameTextField: UIView {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  let textField = UITextField().then {
    $0.placeholder = "닉네임을 입력해주세요"
    $0.textAlignment = .center
    $0.font = Font.H6.M
    $0.textColor = Color.black.color
  }
  
  let removeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = Color.gray500.color
  }
  
  private let bottomBarView = UIView().then {
    $0.backgroundColor = Color.gray300.color
  }
  
  init() {
    super.init(frame: .zero)
    setLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setLayout() {
    self.flex.define {
      $0.addItem()
        .direction(.row)
        .alignItems(.center)
        .define {
          $0.addItem(textField)
            .height(51)
            .grow(1)
          $0.addItem(removeButton)
            .size(24)
        }
      $0.addItem(bottomBarView)
        .width(100%)
        .height(1)
    }
  }
  
}
