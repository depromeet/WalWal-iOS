//
//  UpdateBoostCountUseCaseImp.swift
//  RecordsDomainImp
//
//  Created by 이지희 on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain

import RxSwift

public final class UpdateBoostCountUseCaseImp: UpdateBoostCountUseCase {
  
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(recordId: Int, count: Int) -> Single<Void> {
    recordRepository.postBoostCount(recordId: recordId, count: count)
  }
}
