//
//  MissionRecordCalendarModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordCalendarModel: Codable {
  public let list: [MissionRecordListModel]
  public let nextCursor: MissionRecordCursorModel
  
  public init(dto: MissionRecordCalendarDTO) {
    self.list = dto.list.map{ MissionRecordListModel(dto: $0) }
    self.nextCursor = MissionRecordCursorModel( dto: dto )
  }
}
