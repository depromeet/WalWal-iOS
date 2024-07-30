//
//  WalWalTabBarDependencyFactoryInterface.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import WalWalTabBarCoordinator

public protocol WalWalTabBarDependencyFactory {
  func makeTabBarCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any WalWalTabBarCoordinator
}
