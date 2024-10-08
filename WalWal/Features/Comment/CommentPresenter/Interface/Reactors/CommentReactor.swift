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
  case fetchComments(recordId: Int) /// 전체 댓글을 불러오는 액션
  case postComment(content: String, recordId: Int) /// 댓글을 추가하는 액션
  case replyToComment(parentId: Int, content: String, recordId: Int) /// 대댓글을 추가하는 액션
}


public enum CommentReactorMutation {
  case setComments([FlattenCommentModel]) /// 댓글 데이터를 설정하는 Mutation
}


public struct CommentReactorState {
  public var comments: [FlattenCommentModel] = []
  public var isLoading: Bool = false
  
  public init() { }
}

public protocol CommentReactor: Reactor where Action == CommentReactorAction, Mutation == CommentReactorMutation, State == CommentReactorState {
  
  init(
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase
  )
}