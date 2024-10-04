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
  
  private let rootContainer = UIView().then {
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = Colors.gray300.color.cgColor
  }
  
  private lazy var textView = CustomTextView(
    placeHolderText: placeholderText,
    placeHolderFont: Fonts.KR.B1,
    placeHolderColor: Colors.gray500.color,
    inputText: "",
    inputTextFont: Fonts.KR.H7.M,
    inputTextColor: Colors.gray900.color,
    maxCount: maxCount
  ).then {
    $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 4, right: 16)
  }
  private lazy var textCountLabel = CustomLabel(font: Fonts.EN.Caption).then {
    $0.text = "0/\(maxCount)"
    $0.textColor = Colors.gray300.color
    $0.textAlignment = .right
  }
  
  // MARK: - Properties
  
  public let textEndEditing = PublishRelay<Bool>()
  
  private(set) var textRelay = BehaviorRelay<String>(value: "")
  
  private let placeholderText: String
  
  private let maxCount: Int
  
  private let maxHeight: CGFloat
  
  private let minHeight: CGFloat
  
  private let textCountLabelMargin: CGFloat = 16.adjusted
  
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
    rootContainer.flex
      .grow(1)
      .layout(mode: .adjustHeight)
  }
  
  private func configAttribute() {
    addSubview(rootContainer)
  }
  
  private func configLayout() {
    rootContainer.flex
      .justifyContent(.spaceBetween)
      .height(minHeight)
      .define {
        $0.addItem(textView)
          .minHeight(70.adjusted)
          .width(100%)
        $0.addItem(textCountLabel)
          .marginRight(textCountLabelMargin)
          .marginBottom(textCountLabelMargin)
      }
  }
  
  private func bind() {
    textView.textRelay
      .bind(to: textRelay)
      .disposed(by: disposeBag)
    
    textRelay
      .asDriver()
      .drive(with: self) { owner, text in
        owner.adjustTextViewHeight()
      }
      .disposed(by: disposeBag)
    
    /// 글자 수 Label
    textRelay
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
  
  private func adjustTextViewHeight() {
    let size = textView.sizeThatFits(CGSize(width: frame.width, height: .infinity))
    let margin: CGFloat = textCountLabel.frame.height + 20
    let rootContainerHeight: CGFloat = size.height + margin
    let totalHeight: CGFloat
    
    // rootContainer가 maxHeight인 경우
    if rootContainerHeight > maxHeight {
      totalHeight = maxHeight
      textView.flex.height(max(totalHeight - margin, minHeight))
    } else {
      totalHeight = max(rootContainerHeight, minHeight)
      textView.flex.height(size.height)
    }
    rootContainer.flex.height(totalHeight)
    rootContainer.flex.layout()
    
    textView.isScrollEnabled = rootContainerHeight >= maxHeight
  }
  
}

extension Reactive where Base: ReportTextView {
  var text: Observable<String> {
    return base.textRelay.asObservable()
  }
}
