//
//  CustomInputBox.swift
//  DesignSystem
//
//  Created by Jiyeon on 10/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import Then
import FlexLayout
import PinLayout
import RxSwift

public final class CustomInputBox: UIView {
  
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  private typealias Images = ResourceKitAsset.Images
  
  private let separator = UIView().then {
    $0.backgroundColor = Colors.gray200.color
  }
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  private let inputContainer = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  private let textView = CustomTextView(
    placeHolderText: "댓글을 입력해주세요!",
    placeHolderFont: Fonts.KR.H7.M,
    placeHolderColor: Colors.gray500.color,
    inputText: "",
    inputTextFont: Fonts.KR.H7.M,
    inputTextColor: Colors.black.color
  ).then {
    $0.tintColor = Colors.blue.color
    $0.backgroundColor = .clear
  }
  private let postButton = UIView().then {
    $0.backgroundColor = Colors.walwalOrange.color
  }
  private let buttonImage = UIImageView().then {
    $0.image = Images.postIcon.image
  }
  
  // MARK: - Properties
  
  private let placeHolderText: String?
  
  private let placeHolderFont: UIFont?
  
  private let placeHolderColor: UIColor?
  
  private let inputTintColor: UIColor
  
  private let inputTextColor: UIColor
  
  private let inputTextFont: UIFont
  
  private let inputText: String
  
  public init(
    placeHolderText: String? = nil,
    placeHolderFont: UIFont? = nil,
    placeHolderColor: UIColor? = nil,
    inputText: String? = nil,
    inputTextFont: UIFont,
    inputTextColor: UIColor,
    inputTintColor: UIColor? = nil
  ) {
    self.placeHolderText = placeHolderText
    self.placeHolderFont = placeHolderFont
    self.placeHolderColor = placeHolderColor
    self.inputText = inputText ?? ""
    self.inputTextFont = inputTextFont
    self.inputTextColor = inputTextColor
    self.inputTintColor = inputTintColor ?? Colors.black.color
    super.init(frame: .zero)
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    inputContainer.layer.cornerRadius = inputContainer.height/2
    inputContainer.layer.borderColor = Colors.gray200.color.cgColor
    inputContainer.layer.borderWidth = 1
    
    postButton.layer.cornerRadius = postButton.height/2
    
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  private func configLayout() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .height(58.adjustedHeight)
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(separator)
          .height(1)
        $0.addItem()
          .justifyContent(.center)
          .grow(1)
          .define {
            $0.addItem(inputContainer)
              .marginVertical(9.adjustedHeight)
              .marginLeft(15.adjustedWidth)
              .marginRight(14.adjustedWidth)
          }
        
      }
    
    inputContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .alignItems(.center)
      .define {
        $0.addItem(textView)
          .marginLeft(17.adjustedWidth)
          .grow(1)
        $0.addItem(postButton)
          .margin(5.adjusted)
          .width(46.adjustedWidth)
      }
    
    postButton.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define {
        $0.addItem(buttonImage)
          .size(CGSize(width: 10, height: 14))
          .marginVertical(8.adjusted)
      }
  }
  
  
}
