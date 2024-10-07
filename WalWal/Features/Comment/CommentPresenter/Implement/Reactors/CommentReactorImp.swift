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
  private let useDummyData: Bool
  
  public init(
    getCommentsUsecase: GetCommentsUsecase,
    postCommentUsecase: PostCommentUsecase,
    flattenCommentUsecase: FlattenCommentsUsecase,
    useDummyData: Bool = false
  ) {
    self.getCommentsUsecase = getCommentsUsecase
    self.postCommentUsecase = postCommentUsecase
    self.flattenCommentUsecase = flattenCommentUsecase
    self.useDummyData = useDummyData
    
    self.initialState = State()
  }
  
  // MARK: - 더미 데이터 생성
  func createDummyComments() -> [FlattenCommentModel] {
    let dummyComments: [CommentModel] =  [
      CommentModel(
        parentID: nil,
        commentID: 1,
        content: "이 강아지 정말 귀엽네요!",
        writerID: 1,
        writerNickname: "슬기누나",
        writerProfileImageURL: "https://example.com/image1.png",
        createdAt: "5분 전",
        replyComments: [
          CommentModel(
            parentID: 1,
            commentID: 2,
            content: "저도 그렇게 생각해요!",
            writerID: 2,
            writerNickname: "댕댕이사랑",
            writerProfileImageURL: "https://example.com/image2.png",
            createdAt: "3분 전",
            replyComments: []
          )
        ]
      ),
      CommentModel(
        parentID: nil,
        commentID: 3,
        content: "강아지 수영이 정말 인상적이네요!",
        writerID: 3,
        writerNickname: "수영덕후",
        writerProfileImageURL: "https://example.com/image3.png",
        createdAt: "10분 전",
        replyComments: [
          CommentModel(
            parentID: 3,
            commentID: 4,
            content: "이 강아지 정말 수영을 잘하네요!",
            writerID: 4,
            writerNickname: "물개조련사",
            writerProfileImageURL: "https://example.com/image4.png",
            createdAt: "7분 전",
            replyComments: []
          ),
          CommentModel(
            parentID: 3,
            commentID: 5,
            content: "완전 공감합니다!",
            writerID: 5,
            writerNickname: "강아지사랑꾼",
            writerProfileImageURL: "https://example.com/image5.png",
            createdAt: "6분 전",
            replyComments: []
          )
        ]
      ),
      CommentModel(
        parentID: nil,
        commentID: 6,
        content: "정말 귀여운 강아지네요!",
        writerID: 6,
        writerNickname: "냥냥이",
        writerProfileImageURL: "https://example.com/image6.png",
        createdAt: "20분 전",
        replyComments: []
      )
    ]
    
    return flattenCommentUsecase.execute(comments: dummyComments)
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchComments(let recordId):
      if useDummyData {
        let dummyComments = createDummyComments()
        return .just(Mutation.setComments(dummyComments))
      } else {
        return getCommentsUsecase.execute(recordId: recordId)
          .asObservable()
          .withUnretained(self)
          .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
          .map { Mutation.setComments($0) } /// 전체 댓글 갱신
      }
    case .postComment(let content, let recordId):
      if useDummyData {
        let dummyComments = createDummyComments()
        return .just(Mutation.setComments(dummyComments))
      } else {
        return postCommentUsecase.execute(content: content, recordId: recordId, parentId: nil)
          .asObservable()
          .withUnretained(self)
          .flatMap { owner, _ in owner.getCommentsUsecase.execute(recordId: recordId) }
          .withUnretained(self)
          .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
          .asObservable()
          .map { Mutation.setComments($0) } /// 댓글 추가 후 전체 목록 갱신
      }
    case .replyToComment(let parentId, let content, let recordId):
      if useDummyData {
        let dummyComments = createDummyComments()
        return .just(Mutation.setComments(dummyComments))
      } else {
        return postCommentUsecase.execute(content: content, recordId: recordId, parentId: parentId)
          .asObservable()
          .withUnretained(self)
          .flatMap { owner, _ in owner.getCommentsUsecase.execute(recordId: recordId) }
          .withUnretained(self)
          .map { owner, model in owner.flattenCommentUsecase.execute(comments: model.comments)}
          .asObservable()
          .map { Mutation.setComments($0) } /// 대댓글 추가 후 전체 목록 갱신
      }
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
