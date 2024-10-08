//
//  CommentReactor.swift
//
//  Comment
//
//  Created by 조용인
//

import Foundation
import CommentDomain

import ReactorKit
import RxSwift

public enum CommentReactorAction {
  case fetchComments(recordId: Int) /// 전체 댓글을 불러오는 액션
  case postComment(content: String, recordId: Int) /// 댓글을 추가하는 액션
  case replyToComment(parentId: Int, content: String, recordId: Int) /// 대댓글을 추가하는 액션
  
  // 바텀 시트 관련 Action
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case tapDimView
}


public enum CommentReactorMutation {
  case setComments([FlattenCommentModel]) /// 댓글 데이터를 설정하는 Mutation
  
  // 바텀 시트 관련 Mutation
  case setSheetPosition(CGFloat)
  case dismissSheet
  
}


public struct CommentReactorState {
  public var comments: [FlattenCommentModel] = []
  public var isLoading: Bool = false
  public var sheetPosition: CGFloat = 0
  public var isSheetDismissed: Bool = false
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
