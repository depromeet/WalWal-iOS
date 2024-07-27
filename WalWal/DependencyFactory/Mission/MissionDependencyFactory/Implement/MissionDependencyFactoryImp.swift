//
//  MissionDependencyFactoryImplement.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import MissionDependencyFactory

import WalWalNetwork

import MissionCoordinator
import MissionCoordinatorImp

import MissionData
import MissionDataImp
import MissionDomain
import MissionDomainImp
import MissionPresenter
import MissionPresenterImp

public class MissionDependencyFactoryImp: MissionDependencyFactory {
  
  public init() {
    
  }
  
  public func makeMissionData() -> MissionRepository {
    let networkService = NetworkService()
    return MissionRepositoryImp(networkService: networkService)
  }
  
  public func makeMissionUseCase() -> MissionUseCase {
    return MissionUseCaseImp(missionDataRepository: makeMissionData())
  }
  
  public func makeMissionReactor(coordinator: any MissionCoordinator) -> any MissionReactor {
    return MissionReactorImp(coordinator: coordinator)
  }
  
  public func makeMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController {
    return MissionViewControllerImp(reactor: reactor)
  }
  
  public func makeMissionCoordinator(navigationController: UINavigationController) -> any MissionCoordinator {
    return MissionCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: nil,
      dependencyFactory: self
    )
  }
}
