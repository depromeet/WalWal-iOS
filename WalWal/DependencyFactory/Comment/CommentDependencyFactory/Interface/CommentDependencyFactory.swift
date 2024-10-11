//
//  CommentDependencyFactoryInterface.swift
//
//  Comment
//
//  Created by 조용인
//

import UIKit

import BaseCoordinator

import CommentData
import CommentDomain
import CommentPresenter

public protocol CommentDependencyFactory {
  
  // MARK: - Repository
  
  func injectFeedRepository() -> CommentRepository
  
  // MARK: - UseCase
 
  func injectGetCommentsUseCase() -> GetCommentsUsecase
  func injectPostCommentUsecase() -> PostCommentUsecase
  func injectFlattenCommentsUsecase() -> FlattenCommentsUsecase
  
  // MARK: - Reactor
  
  func injectCommentReactor(
      getCommentsUsecase: GetCommentsUsecase,
      postCommentUsecase: PostCommentUsecase,
      flattenCommentUsecase: FlattenCommentsUsecase,
      recordId: Int,
      writerNickname: String
  ) -> any CommentReactor
  
  // MARK: - ViewController
  
  func injectCommentViewController<T: CommentReactor>(reactor: T) -> any CommentViewController

}
