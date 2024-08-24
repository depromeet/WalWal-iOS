//
//  MissionRecordStartModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RecordsData

public struct MissionRecordStartModel {
  public let recordId: Int
  
  public init(dto: MissionRecordStartDTO) {
    self.recordId = dto.recordId
  }
}
