//
//  FetchMissionRecordListUseCase.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

import RxSwift

public protocol FetchMissionRecordListUseCase {
  func execute(dto: MissionRecordCalendarDTO) -> [MissionRecordListModel]
}
