//
//  PostCommentModel.swift
//  CommentDomain
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import CommentData

// MARK: - PostCommentModel
public struct PostCommentModel {
  public let commentID: Int
  
  public init(dto: PostCommentDTO) {
    self.commentID = dto.commentID
  }
}
