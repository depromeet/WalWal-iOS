//
//  SplashDependencyFactoryInterface.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import AppCoordinator

import SplashData
import SplashDomain
import SplashPresenter

public protocol SplashDependencyFactory {
  func makeAppCoordinator(navigationController: UINavigationController) -> any AppCoordinator
  func makeSplashReactor(coordinator: any AppCoordinator) -> any SplashReactor
  func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController
}
