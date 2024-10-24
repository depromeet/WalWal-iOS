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
        return Images.closeL.image.withTintColor(Colors.gray500.color)
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
        return Images.closeL.image.withTintColor(Colors.gray500.color)
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
  private let textFieldContainer = UIView()
  private let inputContainer = UIView()
  
  fileprivate let textField = UITextField().then {
    $0.textAlignment = .center
    $0.font = Fonts.KR.H6.M
    $0.textColor = Colors.black.color
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
  }
  
  fileprivate let placeholderLabel = CustomLabel(font: Fonts.KR.H6.M).then {
    $0.textColor = Colors.gray500.color
    $0.textAlignment = .center
  }
  
  fileprivate let rightButton: WalWalTouchArea
  
  fileprivate let separatorView = UIView().then {
    $0.backgroundColor = Colors.gray300.color
  }
  
  fileprivate let errorLabel = CustomLabel(font: Fonts.KR.B2).then {
    $0.numberOfLines = 1
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
    rightIcon: WlaWalInputBoxIcon = .none,
    isAlwaysKeyboard: Bool = false
  ) {
    self.rightButton = WalWalTouchArea(image: rightIcon.image)
    self.rightIcon = rightIcon
    self.stateRelay.accept(defaultState)
    super.init(frame: .zero)
    self.textField.delegate = isAlwaysKeyboard ? self : nil
    
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
      .all()
    containerView.flex
      .layout(mode: .adjustHeight)
    
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
    containerView.flex.define {
      $0.addItem()
        .justifyContent(.spaceBetween)
        .height(52.adjustedHeight)
        .define {
          $0.addItem(textFieldContainer)
            .marginTop(15.adjustedHeight)
            .grow(1)
          $0.addItem(separatorView)
            .height(1)
            .marginTop(15.adjustedHeight)
        }
      
      $0.addItem(errorLabel)
        .marginTop(3.adjustedHeight)
        .height(17.adjustedHeight)
    }
    
    textFieldContainer.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .paddingLeft(24.adjustedWidth)
      .paddingRight(2.adjustedWidth)
      .define {
        $0.addItem(inputContainer)
          .grow(1)
        $0.addItem(rightButton)
          .size(20.adjusted)
      }
    
    inputContainer.flex
      .direction(.column)
      .define {
        $0.addItem(textField)
        $0.addItem(placeholderLabel)
          .position(.absolute)
          .all(0)
      }
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
    
    isTextFieldEmpty
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
          owner.textField.text = nil
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
  
  public func focusOnTextField(){
    textField.becomeFirstResponder()
  }
  
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
  
  /// 특정 글자 수 제한에 맞게 자르기 위한 메서드
  public func cutText(length: Int, text: String) {
    let maxIndex = text.index(text.startIndex, offsetBy: length-1)
    let startIndex = text.startIndex
    let cutting = String(text[startIndex...maxIndex])
    textField.text = cutting
  }
}

// MARK: - UITextFieldDelegate

extension WalWalInputBox: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return false
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
  
  public var errorMessageChanged: Observable<String?> {
    return base.errorRelay.asObservable()
  }
}
