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
  
  public private(set) var textView = UITextView().then {
    $0.backgroundColor = .clear
    $0.font = Fonts.KR.H6.B
    $0.isEditable = true
    $0.isScrollEnabled = true
  }
  
  private lazy var characterCountLabel = UILabel().then {
    $0.font = Fonts.EN.Caption
    $0.textColor = Colors.white.color.withAlphaComponent(0.2)
    $0.text = "0/\(maxCharacterCount)"
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
    flex.define { flex in
      flex.addItem(textView).grow(1)
      flex.addItem(characterCountLabel)
        .width(40)
        .alignSelf(.end)
        .marginTop(4)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout(mode: .adjustHeight)
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
    
    /// 현재 텍스트뷰에 나와있는 텍스트가 플레이스홀더인지 일반 텍스트인지에 따라서 AttributeString을 적용
    Observable.combineLatest(textRelay, isPlaceholderVisibleRelay)
      .map { [weak self] (text, isPlaceholderVisible) -> NSAttributedString in
        guard let self = self else { return NSAttributedString() }
        return isPlaceholderVisible ? self.stylePlaceholderText() : self.styleText(text)
      }
      .bind(to: textView.rx.attributedText)
      .disposed(by: disposeBag)
    
    /// 텍스트뷰 글자수 체크 라벨
    textRelay
      .map { [weak self] text -> String in
        guard let self = self else { return "" }
        return "\(text.count)/\(self.maxCharacterCount)"
      }
      .bind(to: characterCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    textView.rx.text.orEmpty
      .asDriver()
      .drive(with: self) { owner, text in
        if text.count > owner.maxCharacterCount {
          owner.cutText(length: owner.maxCharacterCount, text: text)
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
  }
  
  private func stylePlaceholderText() -> NSAttributedString {
    return NSAttributedString(string: placeholderText, attributes: [
      .foregroundColor: Colors.white.color.withAlphaComponent(0.4),
      .font: Fonts.KR.H6.B
    ])
  }
  
  private func styleText(_ text: String) -> NSAttributedString {
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
  func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
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
