//
//  ASAuthorizationControllerProxy.swift
//  AuthView
//
//  Created by 김지연 on 7/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthenticationServices

import RxSwift
import RxCocoa

/// ASAuthorizationControllerDelegate를 Rx로 사용하기 위한 작업
extension ASAuthorizationController: HasDelegate {
  public typealias Delegate = ASAuthorizationControllerDelegate
}

/// AppleLogin 요청 처리를 위한 클래스
/// ASAuthorizationController의 델리게이트 메서드를 Observable로 변환하여 사용하도록 합니다.
class ASAuthorizationControllerProxy:
  DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>{
  var window: UIWindow = UIWindow()
  lazy var didComplete = PublishSubject<String?>()
  
  public init(controller: ASAuthorizationController) {
    super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
  }
  
  deinit {
    didComplete.onCompleted()
  }
}

// MARK: - DelegateProxyType

extension ASAuthorizationControllerProxy: DelegateProxyType {
  /// ASAuthorizationControllerProxy를 델리게이트 프록시로 등록
  static func registerKnownImplementations() {
    register {
      ASAuthorizationControllerProxy(controller: $0)
    }
  }
}

// MARK: - ASAuthorizationControllerDelegate

/// 애플 로그인 인증 처리 델리게이트
extension ASAuthorizationControllerProxy: ASAuthorizationControllerDelegate {
  /// 인증 성공시 호출되는 메서드
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        if let authorizationCode = appleCredential.authorizationCode,
           let authCode = String(data: authorizationCode, encoding: .utf8) {
          didComplete.onNext(authCode)
          didComplete.onCompleted()
        }
      }
  }
  
  /// 인증 실패시 호출되는 메서드
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    didComplete.onError(error)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension ASAuthorizationControllerProxy: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return window
  }
}

// MARK: - Reactive

extension Reactive where Base: ASAuthorizationAppleIDProvider {
  /// 애플 로그인 인증을 수행하고, 윈도우에 애플 로그인 뷰를 띄웁니다.
  ///
  /// 사용 예시
  /// ```swift
  /// ASAuthorizationAppleIDProvider().rx.appleLogin(
  /// scope: [.email, .fullName],
  /// window: self.view.window
  /// )
  /// ```
  /// - Parameters:
  ///   - scope: 요청 scope
  ///   - window: 로그인 UI를 띄우기 위한 UIWindow
  func appleLogin(scope: [ASAuthorization.Scope], window: UIWindow?) -> Observable<String?> {
    guard let window = window else {
      return .never()
    }
    
    let request = base.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    
    let proxy = ASAuthorizationControllerProxy.proxy(for: controller)
    proxy.window = window
    
    controller.presentationContextProvider = proxy
    controller.delegate = proxy
    controller.performRequests()
    
    return proxy.didComplete
  }
}
