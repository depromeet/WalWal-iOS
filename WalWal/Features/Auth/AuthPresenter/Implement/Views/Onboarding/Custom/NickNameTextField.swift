//
//  NicknameTextField.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import Then

final class NicknameTextField: UIView {
  
  let textField = UITextField().then {
    $0.placeholder = "닉네임을 입력해주세요"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 16, weight: .regular)
  }
  
  let removeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = .lightGray
  }
  
  private let bottomBarView = UIView().then {
    $0.backgroundColor = .lightGray
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
