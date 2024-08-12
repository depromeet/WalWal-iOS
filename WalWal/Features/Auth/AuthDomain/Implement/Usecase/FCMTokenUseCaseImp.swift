//
//  FCMTokenUseCaseImp.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData
import AuthDomain
import LocalStorage

import RxSwift

public final class FCMTokenUseCaseImp: FCMTokenUseCase {
  private let authDataRepository: AuthRepository
  
  public init(authDataRepository: AuthRepository) {
    self.authDataRepository = authDataRepository
  }
  
  public func excute() -> Single<Void> {
    return authDataRepository.fcmTokenSave(token: UserDefaults.string(forUserDefaultsKey: .notification))
  }
}
