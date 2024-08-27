//
//  RecordRepository.swift
//  RecordsData
//
//  Created by 조용인 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

import RxSwift

public protocol RecordRepository {
  func saveRecord(missionId: Int, content: String) -> Single<Void>
  func startRecord(missionId: Int) -> Single<MissionRecordStartDTO>
  func checkRecordStatus(missionId: Int) -> Single<MissionRecordStatusDTO>
  func checkCalendarRecords(cursor: String, limit: Int) -> Single<MissionRecordCalendarDTO>
  func checkCompletedTotalRecords(memberId: Int?) -> Single<MissionRecordTotalCountDTO>
  func postBoostCount(recordId: Int, count: Int) -> Single<Void>
}
