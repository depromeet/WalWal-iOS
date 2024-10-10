//
//  PostCommentUsecaseImp.swift
//  CommentDomain
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import CommentData
import CommentDomain

import RxSwift

public final class PostCommentUsecaseImp: PostCommentUsecase {
  public let repository: CommentRepository
  
  public init(repository: CommentRepository) {
    self.repository = repository
  }
  
  public func execute(content: String, recordId: Int, parentId: Int?) -> Single<PostCommentModel> {
    return repository.postComment(content: content, recordId: recordId, parentId: parentId)
      .map { PostCommentModel(dto: $0) }
  }
}

