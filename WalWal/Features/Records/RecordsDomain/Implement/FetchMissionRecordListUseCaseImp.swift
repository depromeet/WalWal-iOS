//
//  FetchMissionRecordListUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsDomain
import RecordsData

import RxSwift

public final class FetchMissionRecordListUseCaseImp: FetchMissionRecordListUseCase {
  
  public func execute(dto: MissionRecordCalendarDTO) -> [MissionRecordListModel] {
    return dto.list.map { MissionRecordListModel(dto: $0) }
  }
}
