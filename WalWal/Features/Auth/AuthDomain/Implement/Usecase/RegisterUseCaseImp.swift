//
//  RegisterUseCaseImp.swift
//  AuthDomainImp
//
//  Created by Jiyeon on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import AuthDomain

import RxSwift


public final class RegisterUseCaseImp: RegisterUseCase {
  
  let authRepository: AuthRepository
  
  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  public func execute(nickname: String, petType: String, defaultProfile: String?) -> Single<AuthToken> {
    return authRepository.register(nickname: nickname, petType: petType, defaultProfile: defaultProfile)
      .map { AuthToken(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
