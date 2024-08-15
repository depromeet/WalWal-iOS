//
//  MissionRecordCursorModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordCursorModel: Codable {
  public let nextCursor: String?
  
  public init(dto: MissionRecordCalendarDTO) {
    self.nextCursor = dto.nextCursor
  }
}
