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

import BaseCoordinator
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
  
  public func injectMissionRepository() -> MissionRepository {
    let networkService = NetworkService()
    return MissionRepositoryImp(networkService: networkService)
  }
  
  
  public func injectTodayMissionUseCase() -> any TodayMissionUseCase {
    return TodayMissionUseCaseImp(missionDataRepository: injectMissionRepository())
  }
  
  public func injectMissionCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?
  ) -> any MissionCoordinator {
    return MissionCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionDependencyFactory: self
    )
  }
  
  public func injectMissionReactor<T: MissionCoordinator>(coordinator: T, todayMissionUseCase: any TodayMissionUseCase ) -> any MissionReactor {
    return MissionReactorImp(
      coordinator: coordinator,
      todayMissionUseCase: injectTodayMissionUseCase()
    )
  }
  
  public func injectMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController {
    return MissionViewControllerImp(reactor: reactor)
  }
}
