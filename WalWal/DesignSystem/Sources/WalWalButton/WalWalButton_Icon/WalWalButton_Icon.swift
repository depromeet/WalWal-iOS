//
//  WalWalButton_Icon.swift
//  DesignSystem
//
//  Created by 조용인 on 8/9/24.
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

public class WalWalButton_Icon: UIControl {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Nested Types
  
  public struct Configuration {
    var backgroundColor: UIColor
    var isEnabled: Bool
  }
  
  // MARK: - UI
  
  private let rootView = UIView()
  
  private let subContainer = UIView()
  
  private lazy var titleLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = Fonts.KR.H7.B
    $0.textColor = Colors.white.color
    $0.text = title
  }
  
  private lazy var iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = icon
  }
  
  // MARK: - Properties
  
  public var title: String? {
    didSet {
      titleLabel.text = title
      titleLabel.sizeToFit()
      iconImageView.sizeToFit()
      layoutSubviews()
    }
  }
  
  public var icon: UIImage? {
    didSet {
      iconImageView.image = icon
      titleLabel.sizeToFit()
      iconImageView.sizeToFit()
      layoutSubviews()
    }
  }
      
  
  fileprivate let buttonType = BehaviorRelay<WalWalButtonType>(value: .active)
  
  fileprivate let disposeBag = DisposeBag()
  
  
  // MARK: - Initialization
  
  public init(type: WalWalButtonType, title: String, icon: UIImage?) {
    super.init(frame: .zero)
    self.title = title
    self.icon = icon
    buttonType.accept(type)
    configureAttributes()
    configureLayouts()
    configureUISet()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    rootView.pin
      .all()
    rootView.flex
      .layout()
    titleLabel.flex
      .markDirty()
  }
  
  // MARK: - Methods
  
  fileprivate func configureAttributes() {
    layer.cornerRadius = 14
    clipsToBounds = true
  }
  
  fileprivate func configureLayouts() {
    addSubview(rootView)
    
    rootView.flex
      .justifyContent(.center)
      .alignItems(.center)
      .height(50.adjusted)
      .define { flex in
        flex.addItem(subContainer)
          .direction(.row)
          .justifyContent(.center)
          .alignItems(.center)
          .define { flex in
            flex.addItem(iconImageView)
              .size(20.adjusted)
              .marginRight(2)
            flex.addItem(titleLabel)
          }
      }
  }
  
  fileprivate func bind() {
    buttonType
      .bind(with:self, onNext: { owner, type in
        owner.configureUISet()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - State Management
  
  fileprivate func setState(_ type: WalWalButtonType) {
    buttonType.accept(type)
  }
  
  fileprivate func configureUISet() {
    let configuration = buttonType.value.configuration
    backgroundColor = configuration.backgroundColor
    isEnabled = configuration.isEnabled
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalButton_Icon {
  /// ## 사용법:
  ///  - 값 직접 대입:
  ///
  ///  ```swift
  ///  button.rx.title.onNext("버튼 타이틀")
  ///  ```
  ///
  ///  - 값 bind:
  ///  ```swift
  ///  Observable.just("버튼 타이틀")
  ///   .bind(to: button.rx.title)
  ///   .disposed(by: disposeBag)
  ///  ```
  ///
  public var title: Binder<String> {
    return Binder(self.base) { button, title in
      button.title = title
    }
  }
  
  /// ## 사용법:
  ///  - 값 직접 대입:
  ///
  ///  ```swift
  ///  button.rx.buttonType.onNext("버튼 타이틀")
  ///  ```
  ///
  ///  - 값 bind:
  ///  ```swift
  ///  Observable.just(WalWalButtonType.inactive)
  ///   .bind(to: button.rx.buttonType)
  ///   .disposed(by: disposeBag)
  ///  ```
  ///
  public var buttonType: Binder<WalWalButtonType> {
    return Binder(self.base) { button, type in
      button.setState(type)
    }
  }
  
  /// ## 사용법:
  ///  - 값 직접 대입:
  ///
  ///  ```swift
  ///  button.rx.icon.onNext("버튼 타이틀")
  ///  ```
  ///
  ///  - 값 bind:
  ///  ```swift
  ///  Observable.just(ResourceKitAsset.images.icon.image)
  ///   .bind(to: button.rx.icon)
  ///   .disposed(by: disposeBag)
  ///  ```
  ///
  public var icon: Binder<UIImage?> {
    return Binder(self.base) { button, icon in
      button.icon = icon
    }
  }
}
