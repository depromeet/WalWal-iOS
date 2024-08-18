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

public protocol FeedDependencyFactory {
  func injectFeedRepository() -> FeedRepository
  func injectFetchFeedUseCase() -> any FetchFeedUseCase
  func makeFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any FeedCoordinator
  func makeFeedReactor<T: FeedCoordinator>(coordinator: T) -> any FeedReactor
  func makeFeedViewController<T: FeedReactor>(reactor: T) -> any FeedViewController
}
