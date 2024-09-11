//
//  WalWalSelectButton.swift
//  DesignSystem
//
//  Created by 이지희 on 9/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import ResourceKit
import RxSwift
import RxCocoa

public enum IconImageType {
  case camera
  case photos
}

public final class WalWalSelectButton: UIView {
  
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily.KR
  
  // MARK: - Property
  
  private let disposeBag = DisposeBag()
  fileprivate let iconImageType = BehaviorRelay<IconImageType>(value: .camera)
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  
  private let titleLabel = CustomLabel(font: Fonts.H6.B).then {
    $0.textColor = Colors.black.color
  }
  
  private let guideLabel = CustomLabel(font: Fonts.B1).then {
    $0.textColor = Colors.gray600.color
    $0.textAlignment = .center
  }
  
  private let iconImageView = UIImageView()
  
  public init(
    titleText: String,
    guideText: String,
    iconImageType: IconImageType
  ) {
    self.titleLabel.text = titleText
    self.guideLabel.text = guideText
    self.iconImageType.accept(iconImageType)
    
    super.init(frame: .zero)
    bind()
    configureLayouts()
    configureAttributes()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  // MARK: - Methods
  
  fileprivate func configureAttributes() {
    backgroundColor = Colors.gray150.color
    clipsToBounds = true
    layer.cornerRadius = 20.adjusted
  }
  
  fileprivate func configureLayouts() {
    addSubview(rootContainer)
    
    
    rootContainer.flex
      .height(180.adjusted)
      .width(160.adjusted)
      .alignItems(.center)
      .justifyContent(.center)
      .define {
        $0.addItem(iconImageView)
          .marginBottom(17.adjusted)
        $0.addItem(titleLabel)
          .marginBottom(3.adjusted)
        $0.addItem(guideLabel)
      }
  }
  
  fileprivate func bind() {
    iconImageType
      .bind(with:self, onNext: { owner, type in
        owner.configureUISet()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - State Management
  
  fileprivate func setState(_ type: IconImageType) {
    iconImageType.accept(type)
  }
  
  fileprivate func configureUISet() {
    iconImageView.image = iconImageType.value == .camera ? Assets.cameraIcon.image : Assets.galleryIcon.image
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalSelectButton {
  ///  - 값 bind:
  ///  ```swift
  ///  Observable.just(WalWalButtonType.inactive)
  ///   .bind(to: button.rx.buttonType)
  ///   .disposed(by: disposeBag)
  ///  ```
  ///
  public var iconImageType: Binder<IconImageType> {
    return Binder(self.base) { button, type in
      button.setState(type)
    }
  }
}
