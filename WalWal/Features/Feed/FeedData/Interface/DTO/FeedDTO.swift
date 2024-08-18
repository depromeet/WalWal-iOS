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
    public let missionID, missionRecordID, authorID: Int
    public let missionRecordImageURL, createdDate: String
    public let totalBoostCount: Int
    public let content: String

    enum CodingKeys: String, CodingKey {
        case missionID = "missionId"
        case missionRecordID = "missionRecordId"
        case authorID = "authorId"
        case missionRecordImageURL = "missionRecordImageUrl"
        case createdDate, totalBoostCount, content
    }
}
