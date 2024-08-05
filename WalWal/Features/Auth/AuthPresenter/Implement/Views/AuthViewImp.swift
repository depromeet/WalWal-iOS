//
//  AuthViewControllerImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import AuthPresenter
import ResourceKit
import Utility
import DesignSystem
import AuthenticationServices
import LocalStorage

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class AuthViewControllerImp<R: AuthReactor>: UIViewController, AuthViewController {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  typealias Image = ResourceKitAsset.Sample
  
  public var disposeBag = DisposeBag()
  public let authReactor: R
  
  // MARK: UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let imageView = UIImageView().then {
    $0.backgroundColor = .clear
    $0.image = Image.authImageSample.image
    $0.contentMode = .scaleAspectFit
  }
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 매일 만나요"
    $0.textColor = Color.black.color
    $0.font = Font.H3
    $0.textAlignment = .center
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "세상 모든 반려동물을 한자리에서!"
    $0.textColor = Color.gray900.color
    $0.font = Font.H7.M
    $0.textAlignment = .center
  }
  private var appleLoginButton = SocialLoginButton(socialType: .apple)
  private var kakaoLoginButton = SocialLoginButton(socialType: .kakao)
  private let buttonHeight = 19+(19.adjustedHeight*2)
  
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
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = Color.walwalOrange.color
    view.addSubview(rootContainer)
    [imageView, titleLabel, subTitleLabel].forEach {
      contentContainer.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.center)
      .define {
        $0.addItem(contentContainer)
          .justifyContent(.center)
          .alignItems(.center)
          .grow(1)
        
        $0.addItem()
          .marginHorizontal(20.adjustedWidth)
          .define {
            $0.addItem(kakaoLoginButton)
              .width(100%)
              .marginBottom(12.adjustedHeight)
              .height(buttonHeight)
            
            $0.addItem(appleLoginButton)
              .width(100%)
              .marginBottom(40.adjustedHeight)
              .height(buttonHeight)
          }
        
        
      }
    imageView.flex
      .marginHorizontal(40.adjusted)
    titleLabel.flex
      .marginTop(16)
      .width(100%)
    subTitleLabel.flex
      .marginTop(6)
      .width(100%)
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
      .map { Reactor.Action.appleLoginTapped(authCode: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    kakaoLoginButton.rx.tap
      .flatMap { _ in
        KakaoLoginManager().kakaoLogin()
      }
      .map { Reactor.Action.kakaoLoginTapped(accessToken: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.pulse(\.$message)
      .asDriver(onErrorJustReturn: "")
      .filter { !$0.isEmpty }
      .drive(with: self) { owner, message in
        Toast.shared.show(message)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.showIndicator }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, show in
        ActivityIndicator.shared.showIndicator.accept(show)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
