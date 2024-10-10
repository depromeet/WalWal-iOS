//
//  FeedDependencyFactoryInterface.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit

import BaseCoordinator
import FeedCoordinator

import FeedData
import FeedDomain
import FeedPresenter

import RecordsDomain
import RecordsDependencyFactory
import CommentDependencyFactory

public protocol FeedDependencyFactory {
  
  func injectFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) -> any FeedCoordinator
  
  // MARK: - Repository
  
  func injectFeedRepository() -> FeedRepository
  
  func injectReportRepostioy() -> ReportRepository
  
  // MARK: - UseCase
  
  func injectFetchFeedUseCase() -> FetchFeedUseCase
  
  func injectFetchUserFeedUseCase() -> FetchUserFeedUseCase
  
  func injectRemoveGlobalRecordIdUseCase() -> RemoveGlobalRecordIdUseCase
  
  func injectReportUseCase() -> ReportUseCase
  
  // MARK: - Reactor
  
  func injectFeedReactor<T: FeedCoordinator>(
    coordinator: T,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase
  ) -> any FeedReactor
  
  func injectFeedMenuReactor<T: FeedCoordinator>(
    coordinator: T,
    recordId: Int
  ) -> any FeedMenuReactor
  
  func injectReportTypeReactor<T: FeedCoordinator>(
    coordinator: T,
    recordId: Int
  ) -> any ReportTypeReactor
  
  func injectReportDetailReactor<T: FeedCoordinator>(
    coordinator: T,
    reportUseCase: ReportUseCase,
    recordId: Int,
    reportType: String
  ) -> any ReportDetailReactor
  
  // MARK: - ViewController
  
  func injectFeedViewController<T: FeedReactor>(reactor: T) -> any FeedViewController
  
  func injectFeedMenuViewController<T: FeedMenuReactor>(reactor: T) -> any FeedMenuViewController
  
  func injectReportTypeViewController<T: ReportTypeReactor>(reactor: T) -> any ReportTypeViewController
  
  func injectReportDetailViewController<T: ReportDetailReactor>(reactor: T) -> any ReportDetailViewController
  
}
