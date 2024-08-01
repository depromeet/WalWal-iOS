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
  
  public func makeMissionRepository() -> MissionRepository {
    let networkService = NetworkService()
    return MissionRepositoryImp(networkService: networkService)
  }
  
  /// MissionUseCase라고 통칭해서 이름을 명명하지 않고, 해당 기능에 대한 이름 명시를 확실하게 해주세요
  public func makeMissionUseCase() -> MissionUseCase {
    return MissionUseCaseImp(missionDataRepository: makeMissionRepository())
  }
  
  public func makeMissionCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any MissionCoordinator {
    return MissionCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionDependencyFactory: self
    )
  }
  
  public func makeMissionReactor<T: MissionCoordinator>(coordinator: T) -> any MissionReactor {
    return MissionReactorImp(
      coordinator: coordinator
    )
  }
  
  public func makeMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController {
    return MissionViewControllerImp(reactor: reactor)
  }
}
