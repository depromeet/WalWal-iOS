//
//  SplashDependencyFactoryInterface.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit

import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MyPageDependencyFactory

import AppCoordinator

public protocol SplashDependencyFactory {
  func makeAppCoordinator(
    navigationController: UINavigationController,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory
  ) -> any AppCoordinator
}
