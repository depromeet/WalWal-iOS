//
//  WalWalTabBarDependencyFactoryInterface.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import MissionDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator

public protocol WalWalTabBarDependencyFactory {
  func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory
  ) -> any WalWalTabBarCoordinator
}
