//
//  SplashDependencyFactoryImplement.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit
import SplashDependencyFactory
import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MyPageDependencyFactory

import WalWalNetwork

import BaseCoordinator
import AppCoordinator
import AppCoordinatorImp

import SplashData
import SplashDataImp
import SplashDomain
import SplashDomainImp

public class SplashDependencyFactoryImp: SplashDependencyFactory {
  
  public init() {
    
  }
  
  public func makeAppCoordinator(
    navigationController: UINavigationController,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory
  ) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      appDependencyFactory: self,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory
    )
  }
}
