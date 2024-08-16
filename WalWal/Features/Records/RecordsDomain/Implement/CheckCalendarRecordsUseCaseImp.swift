//
//  CheckCalendarRecordsUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain

import RxSwift

public final class CheckCalendarRecordsUseCaseImp: CheckCalendarRecordsUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(cursor: String, limit: Int) -> Single<MissionRecordCalendarModel> {
    return recordRepository.checkCalendarRecords(cursor: cursor, limit: limit)
      .map{ MissionRecordCalendarModel(dto: $0) }
  }
}
