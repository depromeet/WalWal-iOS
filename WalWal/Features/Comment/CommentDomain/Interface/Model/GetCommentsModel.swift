//
//  GetCommentsModel.swift
//  CommentDomain
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import CommentData

// MARK: - GetCommentsModel
public struct GetCommentsModel {
  public let comments: [CommentModel]
  
  public init(dto: GetCommentsDTO) {
    self.comments = dto.comments.map { CommentModel(dto: $0) }
  }
}

// MARK: - CommentModel
public struct CommentModel: Hashable {
  public let parentID: Int?
  public let commentID: Int
  public let content: String
  public let writerID: Int
  public let writerNickname: String
  public let writerProfileImageURL: String
  public let createdAt: String
  public let replyComments: [CommentModel]
  
  public init(dto: Comment) {
    self.parentID = dto.parentID
    self.commentID = dto.commentID
    self.content = dto.content
    self.writerID = dto.writerID
    self.writerNickname = dto.writerNickname
    self.writerProfileImageURL = dto.writerProfileImageURL
    self.createdAt = dto.createdAt
    self.replyComments = dto.replyComments.map { CommentModel(dto: $0) }
  }
  
  public init(
    parentID: Int?,
    commentID: Int,
    content: String,
    writerID: Int,
    writerNickname: String,
    writerProfileImageURL: String,
    createdAt: String,
    replyComments: [CommentModel]
  ) {
    self.parentID = parentID
    self.commentID = commentID
    self.content = content
    self.writerID = writerID
    self.writerNickname = writerNickname
    self.writerProfileImageURL = writerProfileImageURL
    self.createdAt = createdAt
    self.replyComments = replyComments
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(commentID)
  }
}
