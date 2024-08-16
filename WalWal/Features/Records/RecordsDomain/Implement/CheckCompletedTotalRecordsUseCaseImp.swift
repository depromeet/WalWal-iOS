//
//  CheckCompletedTotalRecordsUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain

import RxSwift

public final class CheckCompletedTotalRecordsUseCaseImp: CheckCompletedTotalRecordsUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute() -> Single<MissionRecordTotalCountModel> {
    return recordRepository.checkCompletedTotalRecords()
      .map { MissionRecordTotalCountModel(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
