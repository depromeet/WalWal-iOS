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

import BaseCoordinator
import CommentCoordinator
import CommentCoordinatorImp

import CommentData
import CommentDataImp
import CommentDomain
import CommentDomainImp
import CommentPresenter
import CommentPresenterImp

public class CommentDependencyFactoryImp: CommentDependencyFactory {
  
  public init() {
    
  }
  
  public func injectCommentCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordId: Int
  ) -> any CommentCoordinator {
    return CommentCoordinatorImp (
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      commentDependencyFactory: self,
      recordId: recordId
    )
  }
  
  public func injectCommentRepository() -> any CommentRepository {
    let networkService = NetworkService()
    return CommentRepositoryImp(networkService: networkService)
  }
  
  public func injectGetCommentsUseCase() -> any GetCommentsUsecase {
    return GetCommentsUsecaseImp(repository: injectCommentRepository())
  }
  
  public func injectPostCommentUsecase() -> any PostCommentUsecase {
    return PostCommentUsecaseImp(repository: injectCommentRepository())
  }
  
  public func injectFlattenCommentsUsecase() -> any FlattenCommentsUsecase {
    return FlattenCommentsUsecaseImp()
  }
  
  public func injectCommentReactor<T>(
    coordinator: T,
    getCommentsUsecase: any GetCommentsUsecase,
    postCommentUsecase: any PostCommentUsecase,
    flattenCommentUsecase: any FlattenCommentsUsecase,
    recordId: Int
  ) -> any CommentReactor where T: CommentCoordinator {
    return CommentReactorImp(
      coordinator: coordinator,
      getCommentsUsecase: getCommentsUsecase,
      postCommentUsecase: postCommentUsecase,
      flattenCommentUsecase: flattenCommentUsecase,
      recordId: recordId
    )
  }
  
  public func injectCommentViewController<T>(reactor: T) -> any CommentViewController where T : CommentReactor {
    return CommentViewControllerImp(reactor: reactor)
  }
  
}
