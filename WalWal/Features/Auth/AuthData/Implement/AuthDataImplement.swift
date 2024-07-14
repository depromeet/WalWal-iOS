//
//  AuthDataImplement.swift
//
//  Auth
//
//  Created by Jiyeon on .
//

import UIKit
import AuthenticationServices
import WalWalNetwork
import AuthData

import RxSwift

public class AuthDataImplement: AuthDataInterface {
  
  public init() {
//    self.networkService = NetworkService()
  }
  
  public func appleLogin(vc: UIViewController) -> Single<AppleLoginDTO> {
    guard let window = vc.view.window else { return .never() }
    return ASAuthorizationAppleIDProvider().rx.appleLogin(window: window)
      .asSingle()
  }
}
