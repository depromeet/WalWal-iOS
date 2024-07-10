//
//  AuthViewController.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import AuthenticationServices

import ReactorKit
import Then
import PinLayout
import FlexLayout
import AuthReactor


final public class AuthViewController: UIViewController {
  public var disposeBag = DisposeBag()
  
  // MARK: UI
  
  private let rootContainer = UIView()
  private let imageView = UIImageView().then {
    $0.backgroundColor = .lightGray
  }
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 매일 만나요"
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 24)
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "세상 모든 반려동물을 한자리에서!"
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14)
  }
  private let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
  
  // MARK: - View LifeCycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
  }
  
  // MARK: - Layout
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  private func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
  }
  
  private func setLayout() {
    rootContainer.flex.justifyContent(.spaceBetween).define { flex in
      flex.addItem().alignItems(.center).paddingTop(35%).define { flex in
        flex.addItem(imageView).width(55%).aspectRatio(1.0)
        flex.addItem(titleLabel).marginTop(10)
        flex.addItem(subTitleLabel).marginTop(10)
      }
      flex.addItem().marginBottom(40).define { flex in
        flex.addItem(appleLoginButton).marginHorizontal(20).height(56)
      }
    }
  }
  
}

extension AuthViewController: View {
  
  public func bind(reactor: AuthReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  private func bindAction(reactor: AuthReactor) {
    
  }
  
  private func bindState(reactor: AuthReactor) {
    
  }
  
  private func bindEvent() {
    
  }
  
}
