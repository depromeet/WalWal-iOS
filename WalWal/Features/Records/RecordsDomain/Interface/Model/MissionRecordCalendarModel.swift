//
//  MissionRecordCalendarModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import RecordsData

public struct MissionRecordCalendarModel {
  public let list: [MissionRecordListModel]
  public let nextCursor: MissionRecordCursorModel
  
  public init(dto: MissionRecordCalendarDTO) {
    self.list = dto.list.map{ MissionRecordListModel(dto: $0) }
    self.nextCursor = MissionRecordCursorModel( dto: dto )
  }
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalRecords = self.list.map {
      GlobalMissonRecordListModel(
        imageId: $0.imageId,
        imageUrl: $0.imageUrl,
        missionDate: $0.missionDate
      )
    }
    
    globalState.updateCalendarRecord(with: globalRecords)
  }
}
