//
//  TokenDeleteUseCaseImp.swift
//  AuthDomainImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import LocalStorage
import AuthDomain

import RxSwift

public class TokenDeleteUseCaseImp: TokenDeleteUseCase {
  
  public init() { }
  
  public func execute() -> Single<Void> {
    UserDefaults.remove(forUserDefaultKey: .refreshToken)
    let _ = KeychainWrapper.shared.setAccessToken(nil)
    print("토큰 삭제")
    return .just(())
  }
}
