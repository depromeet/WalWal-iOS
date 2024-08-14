//
//  FCMSaveUseCaseImp.swift
//  FCMDomain
//
//  Created by Jiyeon on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMData
import FCMDomain
import LocalStorage

import RxSwift

public final class FCMSaveUseCaseImp: FCMSaveUseCase {
  private let fcmRepository: FCMRepository
  
  public init(fcmRepository: FCMRepository) {
    self.fcmRepository = fcmRepository
  }
  
  public func excute() -> Single<Void> {
    return fcmRepository.fcmTokenSave(token: UserDefaults.string(forUserDefaultsKey: .notification))
  }
}
