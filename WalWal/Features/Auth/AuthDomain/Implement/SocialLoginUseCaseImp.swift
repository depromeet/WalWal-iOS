//
//  SocialLoginUseCaseImp.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import AuthDomain

import RxSwift

public final class SocialLoginUseCaseImp: SocialLoginUseCase {
  private let authDataRepository: AuthRepository
  
  public init(authDataRepository: AuthRepository) {
    self.authDataRepository = authDataRepository
  }
  public func excute(provider: ProviderType, token: String) -> Single<AuthToken> {
    return authDataRepository.socialLogin(provider: provider.rawValue, token: token)
      .map { AuthToken(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
