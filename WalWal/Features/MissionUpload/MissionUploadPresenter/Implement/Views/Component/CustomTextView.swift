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
  public private(set) var textView = UnderlinedTextView(
    font: Fonts.KR.H6.B,
    textColor: Colors.gray600.color,
    tintColor: Colors.walwalOrange.color,
    underLineColor: Colors.gray800.color,
    numberOfLines: 4
  ).then {
    $0.backgroundColor = .clear
    $0.isEditable = true
    $0.isScrollEnabled = false
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 0
    $0.returnKeyType = .done
  }
  private lazy var characterCountLabel = UILabel().then {
    $0.font = Fonts.EN.Caption
    $0.textColor = Colors.white.color.withAlphaComponent(0.2)
    $0.text = "0/80"
    $0.textAlignment = .right
  }
  
  // MARK: - Properties
  
  public private(set) var textRelay: BehaviorRelay<String>
  public private(set) var isPlaceholderVisibleRelay = BehaviorRelay<Bool>(value: true)
  private let placeholderText: String
  private let maxCharacterCount: Int
  private let textViewMinHeight: CGFloat = 151
  
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
    
    textViewContainer.flex
      .define { flex in
        flex.addItem(textView)
          .width(100%)
          .minHeight(textViewMinHeight)
          .grow(1)
        flex.addItem(characterCountLabel)
          .alignSelf(.end)
          .marginTop(6)
          .maxHeight(17)
          .width(100%)
      }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textViewContainer.pin.all()
    textViewContainer.flex.layout(mode: .adjustHeight)
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
        
        if text.last == "\n" {
          owner.textView.endEditing(true)
        }
      }
      .disposed(by: disposeBag)
    
    isPlaceholderVisibleRelay
      .asDriver()
      .drive(with: self) { owner, isPlaceHolder in
        if isPlaceHolder {
          owner.textView.attributedText = owner.stylePlaceholderText()
        } else {
          owner.textView.text = nil
        }
      }
      .disposed(by: disposeBag)
    
    /// 입력 시작되고, 플레이스 홀더가 나와있다면 플레이스 홀더 제거
    textView.rx.didBeginEditing
      .withLatestFrom(isPlaceholderVisibleRelay)
      .filter { $0 }
      .subscribe(with: self, onNext: { owner, _ in
        owner.isPlaceholderVisibleRelay.accept(false)
        owner.textView.text = nil
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
    
    /// 텍스트 뷰에 입력 시 텍스트 스타일 지정
    textView.rx.didChange
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.textView.attributeText()
      }
      .disposed(by: disposeBag)
    
    /// 글자 수 카운트
    textRelay
      .map { "\($0.count)/80"}
      .bind(to: characterCountLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func stylePlaceholderText() -> NSAttributedString {
    return NSAttributedString(string: placeholderText, attributes: [
      .foregroundColor: Colors.white.color.withAlphaComponent(0.4),
      .font: Fonts.KR.H6.B
    ])
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
