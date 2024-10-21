//
//  GetCommentsDTO.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - GetCommentsDTO
public struct GetCommentsDTO: Codable {
  public let comments: [Comment]
}

// MARK: - Comment
public struct Comment: Codable {
  public let parentID: Int?
  public let commentID: Int
  public let content: String
  public let writerID: Int?
  public let writerNickname, writerProfileImageURL, createdAt: String
  public let replyComments: [Comment]
  
  enum CodingKeys: String, CodingKey {
    case parentID = "parentId"
    case commentID = "commentId"
    case content
    case writerID = "writerId"
    case writerNickname
    case writerProfileImageURL = "writerProfileImageUrl"
    case createdAt, replyComments
  }
}
