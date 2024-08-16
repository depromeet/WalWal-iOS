//
//  MissionRecordListModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordListModel {
  public let imageId: Int
  public let imageUrl: String
  public let missionDate: String
  
  public init(dto: MissionRecordListDTO) {
    self.imageId = dto.imageId
    self.imageUrl = dto.imageUrl
    self.missionDate = dto.missionDate
  }
}
