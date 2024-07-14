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
import AuthPresenterReactor
import RxCocoa


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
  
  private var appleLoginButton = SocialLoginButton(socialType: .apple)
  
  // MARK: - View LifeCycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = AuthReactor()
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
        flex.addItem(imageView).size(220)
        flex.addItem(titleLabel).marginTop(10).maxWidth(330)
        flex.addItem(subTitleLabel).marginTop(6).maxWidth(330)
      }
      flex.addItem().marginBottom(40).alignItems(.center).define { flex in
        // 카카오 로그인 버튼 추가하기
        flex.addItem(appleLoginButton).width(330).height(56)
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
    appleLoginButton.rx.tap
      .flatMap { _ in
        ASAuthorizationAppleIDProvider().rx.appleLogin(scope: [.email, .fullName], window: self.view.window)
      }
      .compactMap { $0 }
      .map { Reactor.Action.appleLogin(authCode: $0) }
      .subscribe(reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(reactor: AuthReactor) {
    
  }
  
  private func bindEvent() {
    
  }
  
}

