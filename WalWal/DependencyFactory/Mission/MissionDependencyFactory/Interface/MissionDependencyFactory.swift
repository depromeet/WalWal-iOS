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
  
  func makeMissionData() -> MissionRepository
  func makeMissionUseCase() -> MissionUseCase
  func makeMissionReactor(coordinator: any MissionCoordinator) -> any MissionReactor
  func makeMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController
  func makeMissionCoordinator(navigationController: UINavigationController) -> any MissionCoordinator
}
