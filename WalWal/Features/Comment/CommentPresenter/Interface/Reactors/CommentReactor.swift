//
//  CommentReactor.swift
//
//  Comment
//
//  Created by 조용인
//

import CommentDomain

import ReactorKit
import RxSwift

public enum CommentReactorAction {
  case fetchComments /// 전체 댓글을 불러오는 액션
  case postComment(content: String) /// 댓글을 추가하는 액션
  case replyToComment(parentId: Int, content: String) /// 대댓글을 추가하는 액션
  case setReplyMode(isReply: Bool, parentId: Int?) /// 대댓글 모드 설정 액션
}


public enum CommentReactorMutation {
  case setComments([FlattenCommentModel]) /// 댓글 데이터를 설정하는 Mutation
}


public struct CommentReactorState {
  public var comments: [FlattenCommentModel] = []
  public var isReply: Bool = false // 답글 여부
  public var parentId: Int? = nil  // 대댓글 대상 댓글 ID
  public var isLoading: Bool = false
  public let recordId: Int
  public init(recordId: Int) {
    self.recordId = recordId
  }
}

public protocol CommentReactor: Reactor where Action == CommentReactorAction, Mutation == CommentReactorMutation, State == CommentReactorState {
  
  init(
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase,
    recordId: Int
  )
}
