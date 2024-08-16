//
//  FCMDeleteUseCaseImp.swift
//  FCMDomain
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMData
import FCMDomain
import LocalStorage

import RxSwift

public final class FCMDeleteUseCaseImp: FCMDeleteUseCase {
  private let fcmRepository: FCMRepository
  
  public init(fcmRepository: FCMRepository) {
    self.fcmRepository = fcmRepository
  }
  
  public func execute() -> Single<Void> {
    return fcmRepository.fcmTokenDelete(token: UserDefaults.string(forUserDefaultsKey: .notification))
  }
}
