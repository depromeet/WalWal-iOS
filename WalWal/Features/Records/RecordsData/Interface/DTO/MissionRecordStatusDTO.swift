//
//  MissionRecordStatusDTO.swift
//  RecordsData
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MissionRecordStatusDTO: Decodable {
  public let recordID: Int?
  public let imageURL: String?
  public let status, missionTitle, illustrationURL: String
  public let content, completedAt: String?

  enum CodingKeys: String, CodingKey {
      case recordID = "recordId"
      case imageURL = "imageUrl"
      case status, missionTitle
      case illustrationURL = "illustrationUrl"
      case content, completedAt
  }
}
