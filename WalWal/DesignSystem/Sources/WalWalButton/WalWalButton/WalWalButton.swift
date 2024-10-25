//
//  WalWalButton.swift
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

public class WalWalButton: UIControl {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Nested Types
  
  public struct Configuration {
    var backgroundColor: UIColor
    var titleColor: UIColor? = Colors.white.color
    var font: UIFont? = Fonts.KR.H6.B
    var isEnabled: Bool
  }
  
  // MARK: - UI
  
  private let rootView = UIView()
  
  fileprivate lazy var titleLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = Fonts.KR.H5.B
    $0.text = title
  }
  
  // MARK: - Properties
  
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public var titleColor: UIColor? {
    didSet {
      titleLabel.textColor = titleColor ?? Colors.white.color
    }
  }
  
  fileprivate let buttonType = BehaviorRelay<WalWalButtonType>(value: .active)
  
  fileprivate let disposeBag = DisposeBag()
  
  private let buttonHeight: CGFloat
  
  // MARK: - Initialization
  
  public init(
    type: WalWalButtonType, 
    title: String,
    buttonHeight: CGFloat = 56
  ) {
    self.buttonHeight = buttonHeight
    super.init(frame: .zero)
    self.title = title
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
    rootView.pin.all()
    rootView.flex.layout()
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
      .height(buttonHeight)
      .define { flex in
        flex.addItem(titleLabel)
          .width(100%)
          .height(100%)
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
    titleLabel.textColor = configuration.titleColor
    titleLabel.font = configuration.font
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalButton {
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
}
