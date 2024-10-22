//
//  CommentReactor.swift
//
//  Comment
//
//  Created by 조용인
//

import Foundation
import CommentDomain
import CommentCoordinator

import ReactorKit
import RxSwift

public enum CommentReactorAction {
  // 바텀 시트 관련 Action
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case tapDimView
  case fetchComments /// 전체 댓글을 불러오는 액션
  case postComment(content: String) /// 댓글을 추가하는 액션
  case setReplyMode(isReply: Bool, parentId: Int?) /// 대댓글 모드 설정 액션
  case resetParentId /// 대댓글 모드 해제 액션
  case resetFocusing
}


public enum CommentReactorMutation {
  case setComments([FlattenCommentModel]) /// 댓글 데이터를 설정하는 Mutation
  case setReplyMode(Int?, Bool)
  // 바텀 시트 관련 Mutation
  case setSheetPosition(CGFloat)
  case dismissSheet
  case isNeedFocusing(Bool)
}


public struct CommentReactorState {
  public var comments: [FlattenCommentModel] = []
  public var isReply: Bool = false // 답글 여부
  public var parentId: Int? = nil  // 대댓글 대상 댓글 ID
  public var isLoading: Bool = false
  public var sheetPosition: CGFloat = 0
  public var isSheetDismissed: Bool = false
  public let recordId: Int
  public let writerNickname: String
  public var focusCommentId: Int?
  public var isNeedFocusing: Bool = false
  public var totalComment: Int = 0
  
  public init(
    recordId: Int,
    writerNickname: String,
    focusCommentId: Int?
  ) {
    self.recordId = recordId
    self.writerNickname = writerNickname
    self.focusCommentId = focusCommentId
  }
}

public protocol CommentReactor: Reactor where Action == CommentReactorAction, Mutation == CommentReactorMutation, State == CommentReactorState {
  
  var coordinator: any CommentCoordinator { get }
  
  init(
    coordinator: any CommentCoordinator,
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase,
    recordId: Int,
    writerNickname: String,
    focusCommentId: Int?
  )
}
