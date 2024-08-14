//
//  MissionRecordCalendarDTO.swift
//  RecordsData
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import Foundation

public struct MissionRecordCalendarDTO: Codable {
    let list: [RecordList]
    let nextCursor: String
  
  public struct RecordList: Codable {
      let imageId: Int
      let imageUrl: String
      let missionDate: String
  }
}
