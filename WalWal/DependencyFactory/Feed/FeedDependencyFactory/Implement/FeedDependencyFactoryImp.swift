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
import CommentDependencyFactory

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
  
  public func injectFeedCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) -> any FeedCoordinator {
    return FeedCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      feedDependencyFactory: self,
      recordsDependencyFactory: recordsDependencyFactory,
      commentDependencyFactory: commentDependencyFactory
    )
  }
  
  // MARK: - Repository
  
  public func injectFeedRepository() -> FeedRepository {
    let networkService = NetworkService()
    return FeedRepositoryImp(networkService: networkService)
  }
  
  public func injectReportRepostioy() -> ReportRepository {
    let networkService = NetworkService()
    return ReportRepositoryImp(networkService: networkService)
  }
  
  // MARK: - UseCase
  
  public func injectFetchFeedUseCase() -> FetchFeedUseCase {
    return FetchFeedUseCaseImp(feedRepository: injectFeedRepository())
  }
  
  public func injectFetchUserFeedUseCase() -> FetchUserFeedUseCase {
    return FetchUserFeedUseCaseImp(feedRepository: injectFeedRepository())
  }
  
  public func injectRemoveGlobalRecordIdUseCase() -> RemoveGlobalRecordIdUseCase {
    return RemoveGlobalRecordIdUseCaseImp()
  }
  
  public func injectReportUseCase() -> ReportUseCase {
    return ReportUseCaseImp(reportRepository: injectReportRepostioy())
  }
  
  public func injectFetchSingleFeedUseCase() -> FetchSingleFeedUseCase {
    return FetchSingleFeedUseCaseImp(feedRepository: injectFeedRepository())
  }
  
  // MARK: - Reactor
  
  public func injectFeedReactor<T: FeedCoordinator>(
    coordinator: T,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase,
    fetchSingleFeedUseCase: FetchSingleFeedUseCase
  ) -> any FeedReactor {
    return FeedReactorImp(
      coordinator: coordinator,
      fetchFeedUseCase: fetchFeedUseCase,
      updateBoostCountUseCase: updateBoostCountUseCase,
      removeGlobalRecordIdUseCase: removeGlobalRecordIdUseCase,
      fetchSingleFeedUseCase: fetchSingleFeedUseCase
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
  
  public func injectReportTypeReactor<T:FeedCoordinator>(
    coordinator: T,
    recordId: Int
  )
  -> any ReportTypeReactor {
    return ReportTypeReactorImp(
      coordinator: coordinator,
      recordId: recordId
    )
  }
  
  public func injectReportDetailReactor<T: FeedCoordinator>(
    coordinator: T,
    reportUseCase: ReportUseCase,
    recordId: Int,
    reportType: String
  ) -> any ReportDetailReactor {
    return ReportDetailReactorImp(
      coordinator: coordinator,
      reportUseCase: reportUseCase,
      recordId: recordId,
      reportType: reportType
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
  
  public func injectReportTypeViewController<T: ReportTypeReactor>(
    reactor: T
  ) -> any ReportTypeViewController {
    return ReportTypeViewControllerImp(reactor: reactor)
  }
  
  public func injectReportDetailViewController<T: ReportDetailReactor>(
    reactor: T
  ) -> any ReportDetailViewController {
    return ReportDetailViewControllerImp(reactor: reactor)
  }
}
