//
//  ReadFCMItemUseCaseImp.swift
//  FCMDomainImp
//
//  Created by Jiyeon on 9/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMDomain
import FCMData

import RxSwift

public final class ReadFCMItemUseCaseImp: ReadFCMItemUseCase {
  
  private let fcmRepository: FCMRepository
  public init(fcmRepository: FCMRepository) {
    self.fcmRepository = fcmRepository
  }
  
  public func execute(id: Int) -> Single<Void> {
    return fcmRepository.readNotification(id: id)
  }
  
}
