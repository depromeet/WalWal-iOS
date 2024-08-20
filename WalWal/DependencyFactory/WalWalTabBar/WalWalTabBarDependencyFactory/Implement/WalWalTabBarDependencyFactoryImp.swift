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
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator
import WalWalTabBarCoordinatorImp

public class WalWalTabBarDependencyFactoryImp: WalWalTabBarDependencyFactory {
  
  public init() {
    
  }
  
  public func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) -> any WalWalTabBarCoordinator {
    return WalWalTabBarCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      walwalTabBarDependencyFactory: self,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      recordDependencyFactory: recordDependencyFactory,
      membersDependencyFactory: membersDependencyFactory
    )
  }
  
}
