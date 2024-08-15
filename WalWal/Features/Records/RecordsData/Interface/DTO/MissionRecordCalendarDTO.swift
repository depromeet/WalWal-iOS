//
//  MissionRecordCalendarDTO.swift
//  RecordsData
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import Foundation

public struct MissionRecordCalendarDTO: Codable {
  public let list: [MissionRecordListDTO]
  public let nextCursor: String?
}

public struct MissionRecordListDTO: Codable {
  public let imageId: Int
  public let imageUrl: String
  public let missionDate: String
}
