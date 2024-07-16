//
//  AuthUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import AuthDomain

import RxSwift

public final class AuthUseCaseImpl: AuthUseCase {
  
  private let authDataRepository: AuthDataRepository
  
  public init(authDataRepository: AuthDataRepository) {
    self.authDataRepository = authDataRepository
  }
  
  public func appleLogin(authCode: String) -> Single<AuthToken> {
    return authDataRepository.appleLogin(token: authCode)
      .map { AuthToken(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
