//
//  CommentReactorImp.swift
//
//  Comment
//
//  Created by 조용인
//

import CommentDomain
import CommentPresenter

import ReactorKit
import RxSwift

public final class CommentReactorImp: CommentReactor {
  
  public typealias Action = CommentReactorAction
  public typealias Mutation = CommentReactorMutation
  public typealias State = CommentReactorState
  
  public let initialState: State
  
  private let getCommentsUsecase: GetCommentsUsecase
  private let postCommentUsecase: PostCommentUsecase
  private let flattenCommentUsecase: FlattenCommentsUsecase
  
  public init(
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase,
    recordId: Int
  ) {
    self.getCommentsUsecase = getCommentsUsecase
    self.postCommentUsecase = postCommentUsecase
    self.flattenCommentUsecase = flattenCommentUsecase
    
    self.initialState = State(recordId: recordId)
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchComments:
      let recordId = currentState.recordId
      return getCommentsUsecase.execute(recordId: recordId)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
        .withUnretained(self)
        .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
        .observe(on: MainScheduler.instance)
        .map { Mutation.setComments($0) } /// 전체 댓글 갱신
    case .postComment(let content):
      let recordId = currentState.recordId
      return postCommentUsecase.execute(content: content, recordId: recordId, parentId: nil)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
        .withUnretained(self)
        .flatMap { owner, _ in owner.getCommentsUsecase.execute(recordId: recordId) }
        .withUnretained(self)
        .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
        .asObservable()
        .observe(on: MainScheduler.instance)
        .map { Mutation.setComments($0) } /// 댓글 추가 후 전체 목록 갱신
    case .replyToComment(let parentId, let content):
      let recordId = currentState.recordId
      return postCommentUsecase.execute(content: content, recordId: recordId, parentId: parentId)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asObservable()
        .withUnretained(self)
        .flatMap { owner, _ in owner.getCommentsUsecase.execute(recordId: recordId) }
        .withUnretained(self)
        .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
        .asObservable()
        .observe(on: MainScheduler.instance)
        .map { Mutation.setComments($0) } /// 대댓글 추가 후 전체 목록 갱신
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setComments(comments):
      newState.comments = comments /// 전체 댓글 상태 업데이트
    }
    return newState
  }
}
