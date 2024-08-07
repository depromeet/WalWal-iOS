//
//  RegisterUseCaseImp.swift
//  OnboardingDomain
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import OnboardingDomain

import RxSwift

public final class RegisterUseCaseImp: RegisterUseCase {
  
  let authRepository: AuthRepository
  
  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  public func excute(nickname: String, pet: String) -> Single<RegisterAuthToken> {
    return authRepository.register(nickname: nickname, pet: pet)
      .map { RegisterAuthToken(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
