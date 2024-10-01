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
  
  public func injectRemoveGlobalRecordIdUseCase() -> RemoveGlobalRecordIdUseCase {
    return RemoveGlobalRecordIdUseCaseImp()
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
  
  // MARK: - Reactor
  
  public func injectFeedReactor<T: FeedCoordinator>(
    coordinator: T,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase
  ) -> any FeedReactor {
    return FeedReactorImp(
      coordinator: coordinator,
      fetchFeedUseCase: fetchFeedUseCase,
      updateBoostCountUseCase: updateBoostCountUseCase,
      removeGlobalRecordIdUseCase: removeGlobalRecordIdUseCase
    )
  }
  
  public func injectFeedMenuReactor<T:FeedCoordinator>(
    coordinator: T,
    recordId: Int
  )
  -> any FeedMenuReactor {
    return FeedMenuReactorImp(
      coordinator: coordinator,
      recordId: recordId
    )
  }
  
  // MARK: - ViewController
  
  public func injectFeedViewController<T: FeedReactor>(
    reactor: T
  ) -> any FeedViewController {
    return FeedViewControllerImp(reactor: reactor)
  }
  
  public func injectFeedMenuViewController<T: FeedMenuReactor>(
    reactor: T
  ) -> any FeedMenuViewController {
    return FeedMenuViewControllerImp(reactor: reactor)
  }
  
}
