//
//  WalWalInputBox.swift
//  DesignSystem
//
//  Created by 조용인 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then

public final class WalWalInputBox: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  /// 우측 버튼으로 들어갈 수 있는 케이스...
  /// 케이스 별로 동작 처리가 달라질 수 있음
  public enum WlaWalInputBoxIcon {
    case close
    case show
    case none
    
    /// 임시 이미지
    var image: UIImage? {
      switch self {
      case .close:
        return Images.closeL.image
      case .show:
        return Images.settingL.image.withTintColor(.blue)
      case .none:
        return nil
      }
    }
    
    /// 임시 이미지
    var selectedImage: UIImage? {
      switch self {
      case .close:
        return Images.closeL.image
      case .show:
        return Images.settingL.image.withTintColor(.blue)
      case .none:
        return nil
      }
    }
  }
  
  /// InputBox가 가질 수 있는 State 목록
  public enum InputBoxActiveState {
    case active
    case inActive
  }
  
  // MARK: - UI
  
  fileprivate let containerView = UIView()
  
  fileprivate let textField = UITextField().then {
    $0.textAlignment = .center
    $0.font = Fonts.KR.H6.M
    $0.textColor = Colors.black.color
  }
  
  fileprivate let placeholderLabel = UILabel().then {
    $0.font = Fonts.KR.H6.M
    $0.textColor = Colors.gray500.color
    $0.textAlignment = .center
  }
  
  fileprivate let rightButton: WalWalTouchArea
  
  fileprivate let separatorView = UIView().then {
    $0.backgroundColor = Colors.gray300.color
  }
  
  fileprivate let errorLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.font = Fonts.KR.B2
    $0.minimumScaleFactor = 0.8
    $0.textColor = .red
    $0.textAlignment = .center
  }
  
  // MARK: - Properties
  
  public private(set) var stateRelay = PublishRelay<InputBoxActiveState>()
  
  fileprivate let errorRelay = BehaviorRelay<String?>(value: nil)
  
  private let disposeBag = DisposeBag()
  
  private let rightIcon: WlaWalInputBoxIcon
  
  private let errorColor = UIColor.red
  
  // MARK: - Initializers
  
  public init(
    defaultState: InputBoxActiveState,
    placeholder: String,
    rightIcon: WlaWalInputBoxIcon = .none
  ) {
    self.rightButton = WalWalTouchArea(image: rightIcon.image)
    self.rightIcon = rightIcon
    self.stateRelay.accept(defaultState)
    super.init(frame: .zero)
    
    configureAttributes(placeholder: placeholder)
    configureLayouts()
    bind()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .left()
      .right()
      .top()
      .height(52)
    containerView.flex
      .layout()
    
    errorLabel.pin
      .left()
      .right()
      .top(to: containerView.edge.bottom)
      .marginTop(6)
      .height(20)
    errorLabel.flex
      .layout()
  }
  
  // MARK: - Methods
  
  private func configureAttributes(placeholder: String) {
    placeholderLabel.text = placeholder
    placeholderLabel.textAlignment = .center
    textField.placeholder = ""
    
    rightButton.setImage(rightIcon.image, for: .normal)
    rightButton.setImage(rightIcon.selectedImage, for: .selected)
  }
  
  private func configureLayouts() {
    addSubview(containerView)
    addSubview(errorLabel)
    
    containerView.flex.define { flex in
      flex.addItem()
        .direction(.row)
        .justifyContent(.spaceBetween)
        .alignItems(.center)
        .paddingTop(18)
        .paddingLeft(24)
        .define { flex in
          flex.addItem()
            .grow(1)
            .define { flex in
              flex.addItem(textField)
              flex.addItem(placeholderLabel)
                .position(.absolute)
                .all(0)
            }
          flex.addItem(rightButton)
            .size(24)
        }
      flex.addItem(separatorView)
        .height(1)
        .marginTop(15)
    }
    errorLabel.flex
      .marginTop(8)
  }
  
  private func bind() {
    let isTextFieldActive = Observable.merge(
      textField.rx.controlEvent(.editingDidBegin).map { true },
      textField.rx.controlEvent(.editingDidEnd).map { false }
    ).share(replay: 1)
    
    let isTextFieldEmpty = textField.rx.text.orEmpty
      .map { $0.isEmpty }
      .distinctUntilChanged()
      .share(replay: 1)
    
    textField.rx.text.orEmpty
      .map{ $0.isEmpty}
      .bind(to: rightButton.rx.isHidden)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(isTextFieldActive, isTextFieldEmpty)
      .map { (isActive, isEmpty) in
        return isActive || !isEmpty
      }
      .bind(to: placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    errorRelay
      .bind(to: errorLabel.rx.text)
      .disposed(by: disposeBag)
    
    textField.rx.controlEvent([.editingDidBegin, .editingChanged])
      .map { nil }
      .bind(to: errorRelay)
      .disposed(by: disposeBag)
    
    stateRelay
      .subscribe(with: self, onNext: { owner, state in
        owner.updateAppearance(activeState: state)
      })
      .disposed(by: disposeBag)
    
    switch rightIcon {
    case .close:
      rightButton.rx.tapped
        .subscribe(with: self, onNext: { owner, _ in
          owner.textField.text = ""
          owner.textField.sendActions(for: .valueChanged)
          owner.errorRelay.accept(nil)
        })
        .disposed(by: disposeBag)
    case .show:
      rightButton.rx.tapped
        .bind(to: Binder(self) { inputBox, _ in
          let newValue = !inputBox.textField.isSecureTextEntry
          inputBox.textField.isSecureTextEntry = newValue
        })
        .disposed(by: disposeBag)
    case .none:
      break
    }
  }
  
  // MARK: - Methods
  
  private func updateAppearance(activeState: InputBoxActiveState) {
    switch activeState {
    case .active:
      textField.textColor = Colors.black.color
      isUserInteractionEnabled = true
    case .inActive:
      textField.textColor = Colors.gray500.color
      isUserInteractionEnabled = false
    }
  }
  
  /// textfield text를 직접적으로 변경하기 위한 메서드
  public func changeText(text: String) {
    textField.text = text
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalInputBox {
  public var text: ControlProperty<String?> {
    return base.textField.rx.text
  }
  
  public var errorMessage: Binder<String?> {
    return Binder(base) { inputBox, errorMessage in
      inputBox.errorRelay.accept(errorMessage)
    }
  }
  
  public var endEditing: Binder<Void> {
    return Binder(base) { inputBox, _ in
      inputBox.textField.endEditing(true)
    }
  }
  
  public func controlEvent(_ events: UIControl.Event) -> ControlEvent<Void> {
    let source = self.base.textField.rx.controlEvent(events).map { _ in }
    return ControlEvent(events: source)
  }
}
