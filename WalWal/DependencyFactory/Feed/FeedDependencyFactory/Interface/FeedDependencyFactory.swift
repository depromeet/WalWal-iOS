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
  func makeFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordsDependencyFactory: RecordsDependencyFactory
  ) -> any FeedCoordinator
  func makeFeedReactor<T: FeedCoordinator>(
    coordinator: T,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase
  ) -> any FeedReactor
  func makeFeedViewController<T: FeedReactor>(reactor: T) -> any FeedViewController
}
