//
//  FlattenCommentsUsecase.swift
//  CommentDomain
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public protocol FlattenCommentsUsecase {
  func execute(comments: [CommentModel]) -> [FlattenCommentModel]
}
