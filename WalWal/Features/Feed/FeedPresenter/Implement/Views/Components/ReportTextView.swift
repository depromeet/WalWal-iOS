//
//  ReportTextView.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa

final class ReportTextView: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let textView = UITextView().then {
    $0.textColor = Colors.gray900.color
    $0.font = Fonts.KR.H7.M
    
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = Colors.gray300.color.cgColor
    $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 34, right: 16)
  }
  
  private let textCountLabel = CustomLabel(font: Fonts.EN.Caption).then {
    $0.textColor = Colors.gray300.color
    $0.textAlignment = .right
  }
  
  // MARK: - Properties
  
  public let inputText = BehaviorRelay<String>(value: "")
  public let textEndEditing = PublishRelay<Bool>()
  private let isplaceHolderVisible = BehaviorRelay<Bool>(value: true)
  private let placeholderText: String
  private let maxCount: Int
  private let maxHeight: CGFloat
  private let minHeight: CGFloat
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialize
  
  init(
    placeholder: String,
    maxHeight: CGFloat,
    minHeigh: CGFloat,
    maxCount: Int
  ) {
    self.placeholderText = placeholder
    self.maxHeight = maxHeight
    self.minHeight = minHeigh
    self.maxCount = maxCount
    super.init(frame: .zero)
    
    configAttribute()
    configLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    textCountLabel.pin
      .bottomRight(16.adjusted)
    rootContainer.flex
      .grow(1)
      .layout()
  }
  
  private func configAttribute() {
    addSubview(rootContainer)
    textView.addSubview(textCountLabel)
  }
  
  private func configLayout() {
    rootContainer.flex
      .define {
        $0.addItem(textView)
          .height(minHeight)
          .width(100%)
        $0.addItem()
          .grow(1)
      }
  }
  private func stylePlaceholderText() -> NSAttributedString {
    return NSAttributedString(string: placeholderText, attributes: [
      .foregroundColor: Colors.gray500.color,
      .font: Fonts.KR.B1
    ])
  }
  
  
  private func bind() {
    
    /// placeholder 설정
    isplaceHolderVisible
      .asDriver()
      .drive(with: self) { owner, isVisible in
        if isVisible {
          owner.textView.attributedText = owner.stylePlaceholderText()
        } else {
          owner.textView.text = nil
        }
      }
      .disposed(by: disposeBag)
    
    /// 입력 시작 시 placeholder 제거
    textView.rx.didBeginEditing
      .withLatestFrom(isplaceHolderVisible)
      .filter { $0 }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isplaceHolderVisible.accept(false)
        
      })
      .disposed(by: disposeBag)
    
    /// 입력 끝난 후 placeholder처리
    textView.rx.didEndEditing
      .withLatestFrom(inputText)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isEmpty }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isplaceHolderVisible.accept(true)
      })
      .disposed(by: disposeBag)
    
    /// 입력 값
    textView.rx.text.orEmpty
      .bind(with: self) { owner, text in
        if owner.isplaceHolderVisible.value {
          owner.inputText.accept("")
        } else {
          owner.inputText.accept(text)
        }
      }
      .disposed(by: disposeBag)
    
    inputText
      .map { "\($0.count)/\(self.maxCount)"}
      .bind(to: textCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    textEndEditing
      .asDriver(onErrorJustReturn: true)
      .drive(with: self) { owner, isTextEndEditing in
        owner.textView.resignFirstResponder()
      }
      .disposed(by: disposeBag)
  }
  
}
