//
//  PostCommnetsDTO.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - PostCommentDTO
public struct PostCommentDTO: Codable {
  public let commentID: Int
  
  enum CodingKeys: String, CodingKey {
    case commentID = "commentId"
  }
}
