//
//  CustomInputBox.swift
//  DesignSystem
//
//  Created by Jiyeon on 10/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class CustomInputBox: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  private typealias Images = ResourceKitAsset.Images
  
  private let separator = UIView().then {
    $0.backgroundColor = Colors.gray200.color
  }
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  private let inputContainer = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  fileprivate lazy var textView = CustomTextView(
    placeHolderText: placeHolderText,
    placeHolderFont: placeHolderFont,
    placeHolderColor: placeHolderColor,
    inputText: inputText,
    inputTextFont: inputTextFont,
    inputTextColor: inputTextColor
  ).then {
    $0.tintColor = inputTintColor
    $0.backgroundColor = .clear
  }
  fileprivate lazy var postButton = UIView().then {
    $0.backgroundColor = buttonInactiveColor
  }
  private let buttonImage = UIImageView().then {
    $0.image = Images.postIcon.image
    $0.isUserInteractionEnabled = true
  }
  
  // MARK: - Properties
  
  private let placeHolderText: String?
  
  private let placeHolderFont: UIFont?
  
  private let placeHolderColor: UIColor?
  
  private let inputTintColor: UIColor
  
  private let inputTextColor: UIColor
  
  private let inputTextFont: UIFont
  
  private let inputText: String
  
  private let buttonActiveColor: UIColor
  
  private let buttonInactiveColor: UIColor
  
  fileprivate var buttonEnable: Bool = false
  
  fileprivate let textRelay = PublishRelay<String>()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialize
  
  /// 제출 버튼이 있는 InputBox
  ///
  /// - Parameters:
  ///   - placeHolderText: 플레이스 홀더 들어갈 텍스트 (optional)
  ///   - placeHolderFont: 플레이스 홀더 폰트 (optional)
  ///   - placeHolderColor: 플레이스 홀더 텍스트 컬러 (optional)
  ///   - inputText: 텍스트뷰에 들어갈 기본 텍스트 데이터 (optional)
  ///   - inputTextFont: 텍스트뷰 텍스트 폰트
  ///   - inputTextColor: 텍스트뷰 텍스트 컬러
  ///   - inputTintColor: 텍트스뷰 커서 컬러 (default: black)
  ///   - buttonActiveColor: 제출 버튼 활성 시 컬러
  ///   - buttonInactiveColor: 제출 버튼 비활성화 시 컬러 (defualt: gray400)
  ///   - buttonEnable: 제출 버튼 활성화 여부 (default: false)
  ///
  public init(
    placeHolderText: String? = nil,
    placeHolderFont: UIFont? = nil,
    placeHolderColor: UIColor? = nil,
    inputText: String? = nil,
    inputTextFont: UIFont,
    inputTextColor: UIColor,
    inputTintColor: UIColor? = nil,
    buttonActiveColor: UIColor,
    buttonInactiveColor: UIColor? = nil,
    buttonEnable: Bool = false
  ) {
    self.placeHolderText = placeHolderText
    self.placeHolderFont = placeHolderFont
    self.placeHolderColor = placeHolderColor
    self.inputText = inputText ?? ""
    self.inputTextFont = inputTextFont
    self.inputTextColor = inputTextColor
    self.inputTintColor = inputTintColor ?? Colors.black.color
    self.buttonActiveColor = buttonActiveColor
    self.buttonInactiveColor = buttonInactiveColor ?? Colors.gray400.color
    self.buttonEnable = buttonEnable
    
    super.init(frame: .zero)
    configLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    inputContainer.layer.cornerRadius = inputContainer.height/2
    inputContainer.layer.borderColor = Colors.gray200.color.cgColor
    inputContainer.layer.borderWidth = 1
    
    postButton.layer.cornerRadius = postButton.height/2
    
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configLayout() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .height(58.adjustedHeight)
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(separator)
          .height(1)
        $0.addItem()
          .justifyContent(.center)
          .grow(1)
          .define {
            $0.addItem(inputContainer)
              .height(40.adjustedHeight)
              .marginTop(9.adjustedHeight)
              .marginLeft(15.adjustedWidth)
              .marginRight(14.adjustedWidth)
          }
      }
    
    inputContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .alignItems(.center)
      .define {
        $0.addItem(textView)
          .marginLeft(17.adjustedWidth)
          .grow(1)
        $0.addItem(postButton)
          .width(46.adjustedWidth)
          .height(30.adjustedHeight)
          .justifyContent(.center)
          .marginHorizontal(5.adjustedWidth)
      }
    
    postButton.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define {
        $0.addItem(buttonImage)
          .size(CGSize(width: 10, height: 14))
          .marginVertical(8.adjusted)
      }
  }
  
  private func bind() {
    textView.textRelay
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .bind(to: textRelay)
      .disposed(by: disposeBag)
    
    textRelay
      .map { $0.isEmpty }
      .distinctUntilChanged()
      .bind(with: self) { owner, isEmpty in
        owner.postButton.backgroundColor = isEmpty ? owner.buttonInactiveColor: owner.buttonActiveColor
        owner.buttonEnable = !isEmpty
      }
      .disposed(by: disposeBag)
  }

  public func clearText() {
    textView.textRelay.accept("")
    textView.isplaceHolderVisible.accept(true)
  }
  
}

extension Reactive where Base: CustomInputBox {
  
  public var text: Observable<String> {
    return base.textRelay.asObservable()
  }
  
  /// post button 탭 이벤트
  public var postButtonTap: Observable<Void> {
    return base.postButton.rx.tapGesture()
      .when(.recognized)
      .filter { _ in base.buttonEnable }
      .map { _ in
        textEndEditing.onNext(())
      }
  }
  /// 텍스트뷰 키보드 내려가기
  ///
  /// `inputBox.rx.textEndEditing.onNext()`
  public var textEndEditing: Binder<Void> {
    return Binder(base) { target, _ in
      target.textView.endEditing(true)
    }
  }
  
  /// 텍스트뷰 키보드 올라오기 (입력 시작)
  public var startEditing: Binder<Void> {
    return Binder(base) { target, _ in
      target.textView.becomeFirstResponder() // 키보드 활성화
    }
  }
}
