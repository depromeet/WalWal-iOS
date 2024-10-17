//
//  CommentReactorImp.swift
//
//  Comment
//
//  Created by 조용인
//

import CommentCoordinator
import CommentDomain
import CommentPresenter

import ReactorKit
import RxSwift

public final class CommentReactorImp: CommentReactor {
  
  public typealias Action = CommentReactorAction
  public typealias Mutation = CommentReactorMutation
  public typealias State = CommentReactorState
  
  public let initialState: State
  public let coordinator: any CommentCoordinator
  
  private var recordId: Int
  private var writerNickname: String
  
  private let getCommentsUsecase: GetCommentsUsecase
  private let postCommentUsecase: PostCommentUsecase
  private let flattenCommentUsecase: FlattenCommentsUsecase
  
  public init(
    coordinator: any CommentCoordinator,
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase,
    recordId: Int,
    writerNickname: String,
    focusCommentId: Int?
  ) {
    self.coordinator = coordinator
    
    self.getCommentsUsecase = getCommentsUsecase
    self.postCommentUsecase = postCommentUsecase
    self.flattenCommentUsecase = flattenCommentUsecase
    
    self.recordId = recordId
    self.writerNickname = writerNickname
    self.initialState = State(
      recordId: recordId,
      writerNickname: writerNickname,
      focusCommentId: focusCommentId
    )
  }
  
  /// `transform` 메서드를 사용하여 액션 스트림을 변형합니다.
  public func transform(action: Observable<Action>) -> Observable<Action> {
    /// 초기 액션으로 `initialLoadAction`를 추가
    let initialLoadAction = Observable.just(
      Action.fetchComments
    )
    /// 기존 액션 스트림과 초기 액션 스트림을 병합
    return Observable.merge(initialLoadAction, action)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchComments:
      return fetchCommentData()
    case let .postComment(content):
      return postComment(content: content)
    case let .didPan(translation, _):
      return Observable.just(.setSheetPosition(translation.y))
    case let .didEndPan(velocity):
      return configSheetPosition(yVelocity: velocity.y)
    case .tapDimView:
      return Observable.just(.dismissSheet)
    case let .setReplyMode(isReply, parentId):
      return Observable.just(.setReplyMode(parentId, isReply))
    case .resetParentId:
      return Observable.just(.setReplyMode(nil, false))
    case .resetFocusing:
      return .just(.isNeedFocusing(false))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setComments(comments):
      newState.comments = comments
      newState.isReply = false // 한번 보내면 대댓글 상태 초기화 하자
      newState.parentId = nil // 한번 보내면 parentID도 초기화
    case let .setSheetPosition(position):
      newState.sheetPosition = position
    case .dismissSheet:
      coordinator.reloadFeedAt(recordId)
    case let .setReplyMode(parentId, isReply):
      newState.parentId = parentId
      newState.isReply = isReply
    case let .isNeedFocusing(isNeed):
      newState.isNeedFocusing = isNeed
    }
    return newState
    
  }
}

extension CommentReactorImp {
  
  /// 댓글 리스트 가져오기
  private func fetchCommentData() -> Observable<Mutation> {
    return getCommentsUsecase.execute(recordId: recordId)
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .asObservable()
      .withUnretained(self)
      .map { owner, model in
        owner.flattenCommentUsecase.execute(comments: model.comments)
      }
      .observe(on: MainScheduler.instance)
      .flatMap { item -> Observable<Mutation> in
        return .concat([
          .just(.setComments(item)),
          .just(.isNeedFocusing(self.currentState.focusCommentId != nil ))
        ])
      }
  }
  
  /// 댓글 작성
  private func postComment(content: String) -> Observable<Mutation> {
    let recordId = currentState.recordId
    let parentId = currentState.parentId
    return postCommentUsecase.execute(
      content: content,
      recordId: recordId,
      parentId: parentId
    )
    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    .asObservable()
    .withUnretained(self)
    .flatMap { owner, _ in
      owner.getCommentsUsecase.execute(recordId: recordId)
    }
    .withUnretained(self)
    .map { owner, model in
      owner.flattenCommentUsecase.execute(comments: model.comments)
    }
    .asObservable()
    .observe(on: MainScheduler.instance)
    .map { Mutation.setComments($0) }
  }
  
  /// 바텀시트 위치 조절
  private func configSheetPosition(yVelocity: Double) -> Observable<Mutation> {
    if yVelocity > 1000 {
      return Observable.just(.dismissSheet)
    } else {
      return Observable.just(.setSheetPosition(0))
    }
  }
}
