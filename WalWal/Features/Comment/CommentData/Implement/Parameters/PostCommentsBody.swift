//
//  PostCommentsBody.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct PostCommentsBody: Encodable {
  let content: String
  let recordId: Int
  let parentId: Int?
}
