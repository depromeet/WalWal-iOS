//
//  NicknameTextField.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then

final class NicknameTextField: UIView {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  private var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  private let containerView = UIView()
  let textField = UITextField().then {
    $0.textAlignment = .center
    $0.font = Font.H6.M
    $0.textColor = Color.black.color
    
    $0.attributedPlaceholder = NSAttributedString(
      string: "닉네임을 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: Color.gray500.color]
      
    )
  }
  private let removeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = Color.gray500.color
  }
  
  private let bottomBarView = UIView().then {
    $0.backgroundColor = Color.gray300.color
  }
  
  init() {
    super.init(frame: .zero)
    setLayout()
    bind()
    
    addSubview(containerView)
    containerView.addSubview(removeButton)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin.all()
    containerView.flex.layout(mode: .adjustHeight)
    
    removeButton.pin
      .vCenter(to: textField.edge.vCenter)
      .right()
      .size(24)
  }
  private func setLayout() {
    containerView.flex.define { flex in
      flex.addItem(textField)
        .height(51)
        .width(100%)
      
      flex.addItem(bottomBarView)
        .width(100%)
        .height(1)
    }
  }
  
  private func bind() {
    textField.rx.text.orEmpty
      .asDriver()
      .drive(with: self) { owner, text in
        owner.removeButton.isHidden =  text.isEmpty
      }
      .disposed(by: disposeBag)
    
    removeButton.rx.tap
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.textField.text = nil
      }
      .disposed(by: disposeBag)
  }
  
}
