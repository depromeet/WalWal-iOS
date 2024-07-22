//
//  LoginButton.swift
//  AuthPresenterView
//
//  Created by 김지연 on 7/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout

/// 소셜 로그인 속성을 설정하기 위한 열거형입니다.
enum SocialLoginType {
  case apple
  case kakao
  
  /// 소셜로그인 버튼 타이틀
  var buttonTitle: String {
    switch self {
    case .apple:
      return "Apple로 로그인"
    case .kakao:
      return "카카오로 로그인"
    }
  }
}

/// 소셜 로그인에서 사용하기 위한 UIButton입니다.
/// - Parameters:
///   - socialType
///     - .kakao: 카카오 로그인
///     - .apple: 애플 로그인
final class SocialLoginButton: UIButton {
  
  private var socialType: SocialLoginType = .apple
  private let containerView = UIView().then {
    $0.isUserInteractionEnabled = false
  }
  private let customImageView = UIImageView()
  private let customLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
    $0.textColor = .white
  }
  
  init(socialType: SocialLoginType) {
    super.init(frame: .zero)
    self.socialType = socialType
    setAttributes()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin.all()
    containerView.flex.layout()
    
    customImageView.pin.left(16).vCenter()
    customLabel.pin.hCenter().vCenter()
  }
  
  private func setAttributes() {
    let tintColor: UIColor = socialType == .apple ? .white : .black
    backgroundColor = socialType == .apple ? .black : .yellow
    layer.cornerRadius = 18
    clipsToBounds = true
    
    containerView.backgroundColor = .clear
    addSubview(containerView)
    
    customImageView.tintColor = tintColor
    customImageView.image = UIImage(systemName: "apple.logo")
    customImageView.contentMode = .scaleAspectFit
    
    customLabel.text = socialType.buttonTitle
    customLabel.textColor = tintColor
    customLabel.textAlignment = .center
    
    containerView.addSubview(customImageView)
    containerView.addSubview(customLabel)
  }
  
  private func setLayout() {
    containerView.flex
      .direction(.row)
      .alignItems(.center)
      .define {
        $0.addItem(customImageView)
          .size(22)
        $0.addItem(customLabel)
          .marginLeft(16)
          .grow(1)
      }
  }
}
