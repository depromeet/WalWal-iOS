//
//  AppleLoginUseCaseImp.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import AuthDomain

import RxSwift

public final class AppleLoginUseCaseImp: AppleLoginUseCase {
  
  private let authDataRepository: AuthRepository
  
  public init(authDataRepository: AuthRepository) {
    self.authDataRepository = authDataRepository
  }
  
  public func excute(authCode: String) -> Single<AuthToken> {
    return authDataRepository.appleLogin(token: authCode)
      .map { AuthToken(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
