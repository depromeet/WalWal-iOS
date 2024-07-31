//
//  MissionDependencyFactoryInterface.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator
import MissionCoordinator

import MissionData
import MissionDomain
import MissionPresenter

public protocol MissionDependencyFactory {
  
  func makeMissionRepository() -> MissionRepository
  func makeMissionUseCase() -> MissionUseCase
  func makeMissionCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any MissionCoordinator
}
