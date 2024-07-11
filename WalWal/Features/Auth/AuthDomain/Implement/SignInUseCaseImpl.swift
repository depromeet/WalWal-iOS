//
//  SignInUseCaseImpl.swift
//  AuthDomain
//
//  Created by 조용인 on 7/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import AuthDomain
import AuthData

import RxSwift

public final class SignInUseCaseImpl: SignInUseCase {
  
  // MARK: - Properties
  
  private let authRepository: AuthDataRepository
  
  // MARK: - Initializers
  
  public init(authRepository: AuthDataRepository) {
    self.authRepository = authRepository
  }
  
  // MARK: - Methods
  
  public func execute(
    id: String,
    password: String
  ) -> Single<Token> {
    authRepository.signIn(id: id, password: password).map { Token(dto: $0) }
  }
}
