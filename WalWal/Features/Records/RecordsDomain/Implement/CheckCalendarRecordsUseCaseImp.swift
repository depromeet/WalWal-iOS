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
import GlobalState

import RxSwift

public final class CheckCalendarRecordsUseCaseImp: CheckCalendarRecordsUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(cursor: String, limit: Int, memberId: Int? = nil) -> Single<MissionRecordCalendarModel> {
    return recordRepository.checkCalendarRecords(cursor: cursor, limit: limit, memberId: memberId)
      .map{
        let calendarModel = MissionRecordCalendarModel(dto: $0)
        guard let memberId else  {
          calendarModel.saveToGlobalState()
          return calendarModel
        }
        return calendarModel
      }
  }
}
