//
//  CustomTextView.swift
//  DesignSystem
//
//  Created by Jiyeon on 10/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa

public final class CustomTextView: UITextView {
  
  /// 입력되는 텍스트 데이터
  public let textRelay = BehaviorRelay<String>(value: "")
  
  /// PlaceHolder 보여줄지에 대한 여부
  private let isplaceHolderVisible = BehaviorRelay<Bool>(value: true)
  
  /// PlaceHolder 스타일
  private let placeHolderText: String?
  
  private let placeHolderFont: UIFont?
  
  private let placeHolderColor: UIColor?
  
  /// 입력 텍스트 스타일
  private let inputText: String
  
  private let inputTextFont: UIFont
  
  private let inputTextColor: UIColor
  
  /// 글자 수 제한
  ///
  /// 기본 값으로 가지는 -1은 글자 수 제한이 없는 것을 의미
  private let maxCount: Int
  
  private let disposeBag = DisposeBag()
  
  public init(
    placeHolderText: String? = nil,
    placeHolderFont: UIFont? = nil,
    placeHolderColor: UIColor? = nil,
    inputText: String,
    inputTextFont: UIFont,
    inputTextColor: UIColor,
    maxCount: Int = -1
  ) {
    self.placeHolderText = placeHolderText
    self.placeHolderFont = placeHolderFont
    self.placeHolderColor = placeHolderColor
    self.inputText = inputText
    self.inputTextFont = inputTextFont
    self.inputTextColor = inputTextColor
    self.maxCount = maxCount
    
    super.init(frame: .zero, textContainer: nil)
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func bind() {
    self.rx.text.orEmpty
      .bind(with: self) { owner, text in
        if owner.isplaceHolderVisible.value {
          owner.textRelay.accept("")
        } else {
          owner.textRelay.accept(text)
        }
      }
      .disposed(by: disposeBag)
    
    /// 글자 수 제한 적용
    textRelay
      .asDriver()
      .filter {
        self.maxCount != -1 && $0.count > self.maxCount
      }
      .drive(with: self) { owner, text in
        owner.cutText(length: owner.maxCount, text: text)
      }
      .disposed(by: disposeBag)
    
    /// PlaceHolder 보여줌 유무에 따라 스타일 설정
    isplaceHolderVisible
      .asDriver()
      .drive(with: self) { owner, isVisible in
        if isVisible {
          owner.attributedText = owner.stylePlaceholderText()
        } else {
          owner.attributedText = nil
        }
      }
      .disposed(by: disposeBag)
    
    /// 텍스트 입력 시작 시 PlaceHolder 숨기기
    self.rx.didBeginEditing
      .withLatestFrom(isplaceHolderVisible)
      .filter { $0 }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isplaceHolderVisible.accept(false)
      })
      .disposed(by: disposeBag)
    
    /// 텍스트 입력 완료 시 PlaceHolder 설정
    self.rx.didEndEditing
      .withLatestFrom(textRelay)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { $0.isEmpty }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isplaceHolderVisible.accept(true)
      })
      .disposed(by: disposeBag)
    
    /// 텍스트 입력 시 스타일 적용
    self.rx.didChange
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.configAttritbutedText()
      }
      .disposed(by: disposeBag)
  }
  
}

// MARK: - Text Styles

extension CustomTextView {
  
  /// 입력되는 텍스트 스타일 설정
  private func configAttritbutedText() {
    let paragraphStyle = configureSpacing(font: inputTextFont)
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .font: inputTextFont,
      .foregroundColor: inputTextColor
    ]
    let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
    self.attributedText = attributedString
    self.typingAttributes[.paragraphStyle] = paragraphStyle
  }
  
  /// PlaceHolder 텍스트 스타일 설정
  private func stylePlaceholderText() -> NSAttributedString? {
    if let placeHolderText = placeHolderText,
       let placeHolderColor = placeHolderColor,
       let placeHolderFont = placeHolderFont {
      
      return NSAttributedString(
        string: placeHolderText,
        attributes: [
          .paragraphStyle: configureSpacing(font: placeHolderFont),
          .foregroundColor: placeHolderColor,
          .font: placeHolderFont
        ]
      )
    }
    return nil
  }
  
  /// 글자 수 제한 설정 시 자르기
  private func cutText(length: Int, text: String) {
    let maxIndex = text.index(text.startIndex, offsetBy: length-1)
    let startIndex = text.startIndex
    let cutting = String(text[startIndex...maxIndex])
    self.text = cutting
  }
  
  /// 줄 간격 설정
  private func configureSpacing(font: UIFont) -> NSMutableParagraphStyle {
    let lineHeight = ResourceKitFontFamily.lineHeightPercent(of: font)
    let spacing = ResourceKitFontFamily.spacingPercent(of: font) * font.pointSize / 100
    let style = NSMutableParagraphStyle()
    style.alignment = self.textAlignment
    style.lineSpacing = 1
    
    if let lineHeight = lineHeight {
      let lineHeight = font.pointSize * (lineHeight / 100)
      style.minimumLineHeight = lineHeight
      style.maximumLineHeight = lineHeight
    } else {
      style.minimumLineHeight = font.lineHeight
      style.maximumLineHeight = font.lineHeight
    }
    
    return style
  }
}
