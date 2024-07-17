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

public final class SignInUseCaseImpl: SampleSignInUseCase {
  
  // MARK: - Properties
  
  private let sampleAuthRepository: SampleAuthRepository
  
  // MARK: - Initializers
  
  public init(sampleAuthRepository: SampleAuthRepository) {
    self.sampleAuthRepository = sampleAuthRepository
  }
  
  // MARK: - Methods
  
  public func execute(id: String, password: String) -> Single<SampleToken> {
    sampleAuthRepository.signIn(id: id, password: password)
      .map { SampleTokenImp(dto: $0) }
  }
}
