//
//  CustomTextView.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

final class StyledTextInputView: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI Components
  
  private let textViewContainer = UIView()
  public private(set) var textView = UnderlinedTextView().then {
    $0.backgroundColor = .clear
    $0.font = Fonts.KR.H6.B
    $0.textColor = Colors.gray600.color
    $0.tintColor = Colors.walwalOrange.color
    $0.isEditable = true
    $0.isScrollEnabled = true
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 0
  }
  
  // MARK: - Properties
  
  public private(set) var textRelay: BehaviorRelay<String>
  public private(set) var isPlaceholderVisibleRelay = BehaviorRelay<Bool>(value: true)
  private let placeholderText: String
  private let maxCharacterCount: Int
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  
  init(
    placeholderText: String,
    maxCharacterCount: Int
  ) {
    self.placeholderText = placeholderText
    self.maxCharacterCount = maxCharacterCount
    self.textRelay = BehaviorRelay<String>(value: "")
    
    super.init(frame: .zero)
    
    configureView()
    setupBindings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Configuration
  
  private func configureView() {
    addSubview(textViewContainer)
    
    textViewContainer.flex.define { flex in
      flex.addItem(textView)
        .height(100%)
        .width(100%)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textViewContainer.pin.all()
    textViewContainer.flex.layout()
  }
  
  // MARK: - Bindings
  
  private func setupBindings() {
    
    let textObservable = textView.rx.text.orEmpty.share(replay: 1)
    
    let limitedTextObservable = textObservable
      .scan("") { [weak self] (previous, new) -> String in
        guard let self = self else { return new }
        return new.count <= self.maxCharacterCount ? new : String(new.prefix(self.maxCharacterCount))
      }
      .distinctUntilChanged()
    
    limitedTextObservable
      .bind(to: textRelay)
      .disposed(by: disposeBag)
    
    textView.rx.text.orEmpty
      .asDriver()
      .drive(with: self) { owner, text in
        if text.count > owner.maxCharacterCount {
          owner.cutText(length: owner.maxCharacterCount, text: text)
        }
      }
      .disposed(by: disposeBag)
    
    isPlaceholderVisibleRelay
      .asDriver()
      .drive(with: self) { owner, isPlaceHolder in
        if isPlaceHolder {
          owner.textView.attributedText = owner.stylePlaceholderText()
        } else {
          owner.textView.attributedText = .none
        }
      }
      .disposed(by: disposeBag)
    
    /// 입력 시작되고, 플레이스 홀더가 나와있다면 플레이스 홀더 제거
    textView.rx.didBeginEditing
      .withLatestFrom(isPlaceholderVisibleRelay)
      .filter { $0 }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isPlaceholderVisibleRelay.accept(false)
        owner.textView.text = ""
      })
      .disposed(by: disposeBag)
    
    /// 입력이 종료되고, 텍스트가 없다면 플레이스 홀더 등장
    textView.rx.didEndEditing
      .withLatestFrom(textRelay)
      .filter { $0.isEmpty }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isPlaceholderVisibleRelay.accept(true)
      })
      .disposed(by: disposeBag)
    
    textView.rx.didChange
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.textView.attributeText()
      }
      .disposed(by: disposeBag)
  }
  
  private func stylePlaceholderText() -> NSAttributedString {
    return NSAttributedString(string: placeholderText, attributes: [
      .foregroundColor: Colors.white.color.withAlphaComponent(0.4),
      .font: Fonts.KR.H6.B
    ])
  }
  
  private func styleText(_ text: String) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 32
    let attributedText = NSMutableAttributedString(string: text, attributes: [
      .foregroundColor: Colors.white.color,
      .font: Fonts.KR.H6.B
    ])
    
    text.ranges(of: "왈왈").forEach { range in
      attributedText.addAttribute(
        .foregroundColor,
        value: Colors.walwalOrange.color,
        range: NSRange(range, in: text)
      )
    }
    
    text.ranges(of: "WalWal").forEach { range in
      attributedText.addAttribute(
        .foregroundColor,
        value: Colors.walwalOrange.color,
        range: NSRange(range, in: text)
      )
    }
    if let existingText = textView.text, !existingText.isEmpty {
      let attributedText = NSMutableAttributedString(string: existingText)
      attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
//      textView.attributedText = attributedText
    }
    textView.typingAttributes[.paragraphStyle] = paragraphStyle
    return attributedText
  }
  
  public func cutText(length: Int, text: String) {
    let maxIndex = text.index(text.startIndex, offsetBy: length-1)
    let startIndex = text.startIndex
    let cutting = String(text[startIndex...maxIndex])
    textView.text = cutting
  }
  

}

extension String {
  func ranges(
    of substring: String,
    options: CompareOptions = [],
    locale: Locale? = nil
  ) -> [Range<Index>] {
    var ranges: [Range<Index>] = []
    while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
      ranges.append(range)
    }
    return ranges
  }
}


extension Reactive where Base: StyledTextInputView {
  var text: Observable<String> {
    return base.textRelay.asObservable()
  }
}

class UnderlinedTextView: UITextView {
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  
  func attributeText() {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 22
    
    // 속성 텍스트 설정
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .font: Fonts.KR.H6.B,
      .foregroundColor: Colors.gray600.color
    ]
    let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
    
    // 왈왈
    let walwalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Colors.walwalOrange.color
    ]
    if let range = text.range(of: "왈왈") {
      let nsRange = NSRange(range, in: text)
      attributedString.addAttributes(walwalAttributes, range: nsRange)
    }
    
    if let range = text.range(of: "WalWal") {
      let nsRange = NSRange(range, in: text)
      attributedString.addAttributes(walwalAttributes, range: nsRange)
    }
    
    
    // UITextView에 속성 텍스트 할당
    
    self.attributedText = attributedString
    self.typingAttributes[.paragraphStyle] = paragraphStyle
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setStrokeColor(Colors.gray800.color.cgColor)
    context.setLineWidth(1.0)
    
    let lineHeight: CGFloat = 40
    let lineSpacing: CGFloat = 0  // 줄 간격
    
    var currentBaseline = self.textContainerInset.top + self.textContainer.lineFragmentPadding + lineHeight - (self.font?.lineHeight ?? 0) - 10
    
    let numberOfLines = Int((rect.height / (lineHeight + lineSpacing)).rounded(.down))
    
    for _ in 0...numberOfLines {
      let underlineY = currentBaseline + (self.font?.lineHeight ?? 0)
      context.move(to: CGPoint(x: self.textContainerInset.left, y: underlineY))
      context.addLine(to: CGPoint(x: rect.width - self.textContainerInset.right, y: underlineY))
      context.strokePath()
      currentBaseline += lineHeight + lineSpacing
    }
  }
}
