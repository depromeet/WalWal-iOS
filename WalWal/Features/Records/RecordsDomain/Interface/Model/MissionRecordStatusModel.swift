//
//  MissionRecordStatusModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordStatusModel {
  public let recordId: Int
  public let imageUrl: String
  public let statusMessage: String
  
  public init(dto: MissionRecordStatusDTO) {
    self.recordId = dto.recordId
    self.imageUrl = dto.imageUrl
    self.statusMessage = dto.status
  }
}
