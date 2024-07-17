//
//  AuthViewControllerImp.swift
//
//  Auth
//
//  Created by Jiyeon
//


import UIKit
import AuthPresenter
import AuthenticationServices

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class AuthViewControllerImp<R: AuthReactor>: UIViewController, 
                                                            AuthViewController {
  
  public var disposeBag = DisposeBag()
  public let authReactor: R
  
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
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.authReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = authReactor
  }
  
  // MARK: - Layout
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
  }
  
  public func setLayout() {
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

// MARK: - Binding

extension AuthViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    appleLoginButton.rx.tap
      .flatMap { _ in
        ASAuthorizationAppleIDProvider().rx.appleLogin(scope: [.email, .fullName], window: self.view.window)
      }
      .compactMap { $0 }
      .map { Reactor.Action.appleLogin(authCode: $0) }
      .subscribe(reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}

