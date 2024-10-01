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

public protocol FeedDependencyFactory {
  func injectFeedRepository() -> FeedRepository
  func injectFetchFeedUseCase() -> FetchFeedUseCase
  func injectFetchUserFeedUseCase() -> FetchUserFeedUseCase
  func injectRemoveGlobalRecordIdUseCase() -> RemoveGlobalRecordIdUseCase
  
  func injectFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordsDependencyFactory: RecordsDependencyFactory
  ) -> any FeedCoordinator
  
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
  
  // MARK: - ViewController
  
  func injectFeedViewController<T: FeedReactor>(reactor: T) -> any FeedViewController
  
  func injectFeedMenuViewController<T: FeedMenuReactor>(reactor: T) -> any FeedMenuViewController
  
  func injectReportTypeViewController<T: ReportTypeReactor>(reactor: T) -> any ReportTypeViewController
  
  
}
