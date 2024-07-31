//
//  WalWalTabBarDependencyFactoryImplement.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import WalWalTabBarDependencyFactory
import MissionDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator
import WalWalTabBarCoordinatorImp

public class WalWalTabBarDependencyFactoryImp: WalWalTabBarDependencyFactory {
  
  public init() {
    
  }
  
  public func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory
  ) -> any WalWalTabBarCoordinator {
    return WalWalTabBarCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      walwalTabBarDependencyFactory: self,
      missionDependencyFactory: missionDependencyFactory
    )
  }
  
}
