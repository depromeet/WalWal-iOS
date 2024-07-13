//
//  SampleSignInUseCaseImpl.swift
//  SampleDomainImp
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import SampleData
import SampleDomain

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
