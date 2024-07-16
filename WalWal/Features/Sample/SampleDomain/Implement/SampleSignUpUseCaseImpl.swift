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

public final class SignUpUseCaseImpl: SampleSignUpUseCase {
  
  // MARK: - Properties
  
  private let sampleAuthRepository: SampleAuthRepository
  
  // MARK: - Initializers
  
  public init(sampleAuthRepository: SampleAuthRepository) {
    self.sampleAuthRepository = sampleAuthRepository
  }
  
  // MARK: - Methods
  
  public func execute(nickname: String, profile: Data) -> Single<SampleToken> {
    sampleAuthRepository.signUp(nickname: nickname, profile: profile)
      .map { SampleToken(dto: $0) }
  }
}
