//
//  WithdrawUseCaseImp.swift
//  AuthDomainImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain
import AuthData

import RxSwift

public final class WithdrawUseCaseImp: WithdrawUseCase {
  private let authRepository: AuthRepository
  
  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  public func execute() -> Single<Void> {
    return authRepository.withdraw()
  }
  
}
