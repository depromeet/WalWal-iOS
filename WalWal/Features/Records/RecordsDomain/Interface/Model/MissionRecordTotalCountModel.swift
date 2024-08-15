//
//  MissionRecordTotalCountModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordTotalCountModel: Codable {
  public let totalCount: Int
  
  public init(dto: MissionRecordTotalCountDTO) {
    self.totalCount = dto.totalCount
  }
}
