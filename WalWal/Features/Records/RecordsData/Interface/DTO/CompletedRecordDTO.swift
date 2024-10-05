//
//  CompletedRecordDTO.swift
//  RecordsData
//
//  Created by 이지희 on 9/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation


public struct CompletedRecordDTO: Codable {
  public let status: String
  public let list: [RecordDTO]
}

// MARK: - RecordList
public struct RecordDTO: Codable {
  public let recordID: Int
  public let imageURL, status, missionTitle, illustrationURL: String
  public let content, completedAt: String

  enum CodingKeys: String, CodingKey {
      case recordID = "recordId"
      case imageURL = "imageUrl"
      case status, missionTitle
      case illustrationURL = "illustrationUrl"
      case content, completedAt
  }
}
