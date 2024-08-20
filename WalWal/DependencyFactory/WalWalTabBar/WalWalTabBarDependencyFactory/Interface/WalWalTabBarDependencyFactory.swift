//
//  WalWalTabBarDependencyFactoryInterface.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import MissionDependencyFactory
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator

public protocol WalWalTabBarDependencyFactory {
  func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) -> any WalWalTabBarCoordinator
}
