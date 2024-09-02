//
//  FCMListUseCaseImp.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMData
import FCMDomain

import RxSwift

public final class FCMListUseCaseImp: FCMListUseCase {
  private let fcmRepository: FCMRepository
  
  public init(fcmRepository: FCMRepository) {
    self.fcmRepository = fcmRepository
  }
  
  public func execute(cursor: String?, limit: Int = 10) -> Single<FCMListModel> {
    return fcmRepository.fetchFCMList(cursor: cursor, limit: limit)
      .map { FCMListModel(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
