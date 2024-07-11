//
//  SignUpUseCaseImpl.swift
//  AuthDomain
//
//  Created by 조용인 on 7/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import AuthDomain
import AuthData

import RxSwift

public final class SignUpUseCaseImpl: SignUpUseCase {
  
  // MARK: - Properties
  
  private let authRepository: AuthDataRepository
  
  // MARK: - Initializers
  
  public init(authRepository: AuthDataRepository) {
    self.authRepository = authRepository
  }
  
  // MARK: - Methods
  
  public func execute(
    nickname: String,
    profile: Data
  ) -> Single<Token> {
    authRepository.signUp(nickname: nickname, profile: profile).map { Token(dto: $0) }
  }
}
