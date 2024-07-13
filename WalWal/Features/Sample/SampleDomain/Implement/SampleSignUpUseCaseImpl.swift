//
//  SampleSignUpUseCaseImpl.swift
//  SampleDomainImp
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import SampleData
import SampleDomain

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
