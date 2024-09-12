//
//  FeedDTO.swift
//  FeedData
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - FeedDTO
public struct FeedDTO: Codable {
  public let list: [FeedListDTO]
  public let nextCursor: String?
}

// MARK: - List
public struct FeedListDTO: Codable {
  public let missionID: Int
  public let missionTitle: String
  public let missionRecordID, authorID: Int
  public let authorProfileNickname, createdDate: String
  public let authorProfileImageURL: String?
  public let missionRecordImageURL: String?
  public let totalBoostCount: Int
  public let content: String?
  
  enum CodingKeys: String, CodingKey {
    case missionID = "missionId"
    case missionTitle
    case missionRecordID = "missionRecordId"
    case authorID = "authorId"
    case authorProfileNickname
    case authorProfileImageURL = "authorProfileImageUrl"
    case missionRecordImageURL = "missionRecordImageUrl"
    case createdDate, totalBoostCount, content
  }
}
