//
//  FeedDependencyFactoryImplement.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import FeedDependencyFactory
import RecordsDependencyFactory

import WalWalNetwork

import BaseCoordinator
import FeedCoordinator
import FeedCoordinatorImp

import FeedData
import FeedDataImp
import FeedDomain
import FeedDomainImp
import FeedPresenter
import FeedPresenterImp

import RecordsDomain

public class FeedDependencyFactoryImp: FeedDependencyFactory {
  
  public init() { }
  
  public func injectFeedRepository() -> FeedRepository {
    let networkService = NetworkService()
    return FeedRepositoryImp(networkService: networkService)
  }
  
  public func injectFetchFeedUseCase() -> FetchFeedUseCase {
    return FetchFeedUseCaseImp(feedRepository: injectFeedRepository())
  }
  
  public func injectFetchUserFeedUseCase() -> FetchUserFeedUseCase {
    return FetchUserFeedUseCaseImp(feedRepository: injectFeedRepository())
  }
  
  public func injectFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordsDependencyFactory: RecordsDependencyFactory
  ) -> any FeedCoordinator {
    return FeedCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      feedDependencyFactory: self,
      recordsDependencyFactory: recordsDependencyFactory
    )
  }
  public func injectFeedReactor<T>(
    coordinator: T,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase
  ) -> any FeedReactor where T : FeedCoordinator {
    return FeedReactorImp(
      coordinator: coordinator,
      fetchFeedUseCase: fetchFeedUseCase,
      updateBoostCountUseCase: updateBoostCountUseCase
    )
  }
  
  public func injectFeedViewController<T>(reactor: T) -> any FeedViewController where T : FeedReactor {
    return FeedViewControllerImp(reactor: reactor)
  }
  
}
