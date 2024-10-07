//
//  FlattenCommentsUsecaseImp.swift
//  CommentDomainImp
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import CommentDomain

import RxSwift

public final class FlattenCommentsUsecaseImp: FlattenCommentsUsecase {
  public init() { }
  
  public func execute(comments: [CommentModel]) -> [FlattenCommentModel] {
    return flatten(comments)
  }
  
  private func flatten(_ comments: [CommentModel]) -> [FlattenCommentModel] {
    var result = [FlattenCommentModel]()
    
    for comment in comments {
      let flatComment = FlattenCommentModel(
        parentID: comment.parentID,
        commentID: comment.commentID,
        content: comment.content,
        writerID: comment.writerID,
        writerNickname: comment.writerNickname,
        writerProfileImageURL: comment.writerProfileImageURL,
        createdAt: comment.createdAt
      )
      result.append(flatComment)
      result.append(contentsOf: flatten(comment.replyComments))
    }
    
    return result
  }
}
