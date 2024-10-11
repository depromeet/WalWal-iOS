//
//  CommentDependencyFactoryImplement.swift
//
//  Comment
//
//  Created by 조용인
//

import UIKit
import WalWalNetwork

import CommentDependencyFactory

import CommentData
import CommentDataImp
import CommentDomain
import CommentDomainImp
import CommentPresenter
import CommentPresenterImp

public class CommentDependencyFactoryImp: CommentDependencyFactory {
  
  public init() {
    
  }
  
  public func injectFeedRepository() -> any CommentRepository {
    let networkService = NetworkService()
    return CommentRepositoryImp(networkService: networkService)
  }
  
  public func injectGetCommentsUseCase() -> any GetCommentsUsecase {
    return GetCommentsUsecaseImp(repository: injectFeedRepository())
  }
  
  public func injectPostCommentUsecase() -> any PostCommentUsecase {
    return PostCommentUsecaseImp(repository: injectFeedRepository())
  }
  
  public func injectFlattenCommentsUsecase() -> any FlattenCommentsUsecase {
    return FlattenCommentsUsecaseImp()
  }
  
  public func injectCommentReactor(
    getCommentsUsecase: any GetCommentsUsecase,
    postCommentUsecase: any PostCommentUsecase,
    flattenCommentUsecase: any FlattenCommentsUsecase,
    recordId: Int,
    writerNickname: String
  ) -> any CommentReactor {
    return CommentReactorImp(
      getCommentsUsecase: getCommentsUsecase,
      postCommentUsecase: postCommentUsecase,
      flattenCommentUsecase: flattenCommentUsecase,
      recordId: recordId,
      writerNickname: writerNickname
    )
  }
  
  public func injectCommentViewController<T>(reactor: T) -> any CommentViewController where T : CommentReactor {
    return CommentViewControllerImp(reactor: reactor)
  }
  
}
