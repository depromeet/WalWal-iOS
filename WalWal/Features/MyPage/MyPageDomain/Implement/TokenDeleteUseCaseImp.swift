//
//  TokenDeleteUseCaseImp.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import LocalStorage

import RxSwift

public class TokenDeleteUseCaseImp: TokenDeleteUseCase {
  public func execute() {
    UserDefaults.remove(forUserDefaultKey: .refreshToken)
    let _ = KeychainWrapper.shared.setAccessToken(nil)
  }
}
