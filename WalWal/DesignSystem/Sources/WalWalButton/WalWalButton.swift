//
//  WalWalButton.swift
//  DesignSystem
//
//  Created by 조용인 on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit
import ResourceKit

import PinLayout
import FlexLayout
import Then
import RxSwift
import RxCocoa

public final class WalWalButton: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  fileprivate let rootView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let titleLabel = UILabel().then {
    $0.textAlignment = .center
    $0.sizeToFit()
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Properties
  
  fileprivate let type: WalWalButtonType
  private var title: String
  private let titleColor: UIColor
  private let _backgroundColor: UIColor
  private var disabledTitle: String?
  private var disabledTitleColor: UIColor?
  private var disabledBackgroundColor: UIColor?
  private var image: UIImage?
  private let disposeBag = DisposeBag()
  
  public private(set) var isEnabled = BehaviorRelay<Bool>(value: true)
  
  // MARK: - Initializers
  
  /// WalWalButton을 초기화합니다. (type에 따라서, 폰트와 각종 요소가 분기됩니다!)
  /// - Parameters:
  ///  - type: 버튼 타입
  ///  - title: 버튼 타이틀
  ///  - disabledTitle: 선택된 버튼 타이틀
  ///  - titleColor: 버튼 타이틀 색상
  ///  - disabledTitleColor: 선택된 버튼 타이틀 색상
  ///  - backgroundColor: 버튼 배경 색상
  ///  - disabledBackgroundColor: 선택된 버튼 배경 색상
  ///  - image: 버튼 이미지
  public init(
    type: WalWalButtonType,
    title: String,
    titleColor: UIColor = ResourceKitAsset.Colors.black.color,
    backgroundColor: UIColor,
    disabledTitle: String? = nil,
    disabledTitleColor: UIColor? = nil,
    disabledBackgroundColor: UIColor? = nil,
    image: UIImage? = nil
  ) {
    self.type = type
    self.title = title
    self.titleColor = titleColor
    self._backgroundColor = backgroundColor
    self.disabledTitle = disabledTitle
    self.disabledTitleColor = disabledTitleColor
    self.disabledBackgroundColor = disabledBackgroundColor
    self.image = image
    super.init(frame: .zero)
    configureAttribute()
    configureLayouts()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.rootView.pin.all()
    self.rootView.flex.layout()
  }
  
  // MARK: Methods
  
  private func configureAttribute() {
    if disabledTitle == nil { disabledTitle = title }
    if disabledTitleColor == nil { disabledTitleColor = titleColor }
    if disabledBackgroundColor == nil { disabledBackgroundColor = _backgroundColor }
    
    self.rootView.backgroundColor = _backgroundColor
    self.rootView.layer.cornerRadius = self.type.cornerRadius
    self.rootView.clipsToBounds = true
    
    self.titleLabel.font = self.type.font
    self.titleLabel.text = self.title
    self.titleLabel.textColor = self.titleColor
    
    self.imageView.image = self.image
  }
  
  private func configureLayouts() {
    self.addSubview(self.rootView)
    
    self.rootView.flex
      .justifyContent(.center)
      .alignItems(.center)
      .direction(.row)
      .define { flex in
        if self.image != nil { flex.addItem(self.imageView).size(20) }
        flex.addItem(self.titleLabel)
          .height(22)
          .alignSelf(.center)
          .marginVertical(self.type.marginVertical)
      }
  }
  
  private func bind() {
    self.isEnabled
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] isEnabled in
        guard let self = self else { return }
        self.titleLabel.text = isEnabled ? self.title : self.disabledTitle
        self.titleLabel.textColor = isEnabled ? self.titleColor : self.disabledTitleColor
        self.rootView.backgroundColor = isEnabled ? self._backgroundColor : self.disabledBackgroundColor
        self.rootView.isUserInteractionEnabled = isEnabled
      })
      .disposed(by: disposeBag)
  }
}
