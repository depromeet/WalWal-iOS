//
//  MissionRecordCalendarDTO.swift
//  RecordsData
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import Foundation

public struct MissionRecordCalendarDTO: Decodable {
  public let list: [MissionRecordListDTO]
  public let nextCursor: String?
}

public struct MissionRecordListDTO: Decodable {
  public let recordId: Int
  public let imageUrl: String?
  public let missionDate: String
}
