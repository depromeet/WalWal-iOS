//
//  FlattenCommentModel.swift
//  CommentDomainImp
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - FlattenCommentModel
public struct FlattenCommentModel: Hashable {
  public let parentID: Int?
  public let commentID: Int
  public let content: String
  public let writerID: Int?
  public let writerNickname: String
  public let writerProfileImageURL: String
  public let createdAt: String
  
  public init(
    parentID: Int?,
    commentID: Int,
    content: String,
    writerID: Int?,
    writerNickname: String,
    writerProfileImageURL: String,
    createdAt: String
  ) {
    self.parentID = parentID
    self.commentID = commentID
    self.content = content
    self.writerID = writerID
    self.writerNickname = writerNickname
    self.writerProfileImageURL = writerProfileImageURL
    self.createdAt = createdAt
  }
}

