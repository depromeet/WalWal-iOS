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
  
  private let rootView = UIView().then {
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
  
  private let type: WalWalButtonType
  private var title: String
  private let titleColor: UIColor
  private var image: UIImage?
  private let _backgroundColor: UIColor
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  /// WalWalButton을 초기화합니다. (type에 따라서, 폰트와 각종 요소가 분기됩니다!)
  /// - Parameters:
  ///  - type: 버튼 타입
  ///  - title: 버튼 타이틀
  ///  - titleColor: 버튼 타이틀 색상
  ///  - image: 버튼 이미지
  ///  - backgroundColor: 버튼 배경 색상
  public init(
    type: WalWalButtonType,
    title: String,
    titleColor: UIColor = ResourceKitAsset.Colors.black.color,
    image: UIImage? = nil,
    backgroundColor: UIColor
  ) {
    self.type = type
    self.title = title
    self.titleColor = titleColor
    self.image = image
    self._backgroundColor = backgroundColor
    
    super.init(frame: .zero)
    configureAttribute()
    configureLayouts()
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
}
