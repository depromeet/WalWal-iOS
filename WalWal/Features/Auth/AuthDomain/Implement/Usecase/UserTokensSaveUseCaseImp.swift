//
//  UserTokensSaveUseCaseImp.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain
import LocalStorage

public class UserTokensSaveUseCaseImp: UserTokensSaveUseCase {
  
  public init() { }
  
  public func execute(tokens: AuthToken) {
    if tokens.isTemporaryToken {
      UserDefaults.setValue(value: tokens.accessToken, forUserDefaultKey: .temporaryToken)
      if KeychainWrapper.shared.accessToken != nil {
        let _ = KeychainWrapper.shared.setAccessToken(nil)
      }
    } else {
      UserDefaults.setValue(value: tokens.refreshToken, forUserDefaultKey: .refreshToken)
      let _ = KeychainWrapper.shared.setAccessToken(tokens.accessToken)
    }
  }
}
