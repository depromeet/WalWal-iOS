//
//  WalWalTabBarDependencyFactoryInterface.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import MissionDependencyFactory
import MissionUploadDependencyFactory
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator

public protocol WalWalTabBarDependencyFactory {
  func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any WalWalTabBarCoordinator
}
