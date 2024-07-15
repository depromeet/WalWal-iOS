//
//  AuthUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain
import AuthData

import RxSwift

public final class AuthUseCaseImpl: AuthUseCase {
  
  private let authDataRepository: AuthDataRepository
  
  init(authDataRepository: AuthDataRepository) {
    self.authDataRepository = authDataRepository
  }
  
  public func appleLogin(authCode: String) -> Single<AuthToken> {
    return authDataRepository.appleLogin(token: authCode)
      .map { $0.toModel() }
      .asObservable()
      .asSingle()
  }
}
