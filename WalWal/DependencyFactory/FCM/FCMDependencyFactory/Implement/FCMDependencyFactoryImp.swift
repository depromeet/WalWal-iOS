//
//  FCMDependencyFactoryImplement.swift
//
//  FCM
//
//  Created by Jiyeon
//

import UIKit
import FCMDependencyFactory

import WalWalNetwork

import BaseCoordinator
import FCMCoordinator
import FCMCoordinatorImp

import FCMPresenter
import FCMPresenterImp
import FCMData
import FCMDataImp
import FCMDomain
import FCMDomainImp

public class FCMDependencyFactoryImp: FCMDependencyFactory {
  
  public init() { }
  
  public func injectFCMCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any FCMCoordinator {
    return FCMCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      fcmDependencyFactory: self
    )
  }
  
  public func injectFCMReactor<T>(
    coordinator: T,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase,
    saveFeedRecordIDUseCase: SaveFeedRecordIDUseCase,
    removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase
  ) -> any FCMReactor where T : FCMCoordinator {
    return FCMReactorImp(
      coordinator: coordinator,
      fetchFCMListUseCase: fetchFCMListUseCase,
      fcmListUseCase: fcmListUseCase,
      readFCMItemUseCase: readFCMItemUseCase,
      saveFeedRecordIDUseCase: saveFeedRecordIDUseCase,
      removeGlobalFCMListUseCase: removeGlobalFCMListUseCase
    )
  }
  
  public func injectFCMViewController<T>(reactor: T) -> any FCMViewController where T : FCMReactor {
    return FCMViewControllerImp(reactor: reactor)
  }
  
  public func injectFCMRepository() -> FCMRepository {
    let networkService = NetworkService()
    return FCMRepositoryImp(networkService: networkService)
  }
  
  public func injectFCMSaveUseCase() -> FCMSaveUseCase {
    return FCMSaveUseCaseImp(fcmRepository: injectFCMRepository())
  }
  
  public func injectFCMDeleteUseCase() -> FCMDeleteUseCase {
    return FCMDeleteUseCaseImp(fcmRepository: injectFCMRepository())
  }
  
  public func injectFCMListUseCase() -> FCMListUseCase {
    return FCMListUseCaseImp(
      fcmRepository: injectFCMRepository(),
      saveFCMListGlobalStateUseCase: injectSaveFCMListGlobalStateUseCase()
    )
  }
  
  public func injectSaveFCMListGlobalStateUseCase() -> SaveFCMListGlobalStateUseCase {
    return SaveFCMListGlobalStateUseCaseImp()
  }
  
  public func injectFetchFCMListUseCase() -> FetchFCMListUseCase {
    return FetchFCMListUseCaseImp()
  }
  
  public func injectReadFCMItemUseCase() -> ReadFCMItemUseCase {
    return ReadFCMItemUseCaseImp(fcmRepository: injectFCMRepository())
  }
  
  public func injectGlobalRemoveFCMListUseCase() -> RemoveGlobalFCMListUseCase {
    return RemoveGlobalFCMListUseCaseImp()
  }
  
  public func injectSaveFeedRecordIDUseCase() -> SaveFeedRecordIDUseCase {
    return SaveFeedRecordIDUseCaseImp()
  }
}
