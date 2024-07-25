//
//  SplashDependencyFactoryImplement.swift
//
//  Splash
//
//  Created by 조용인
//

import UIKit
import SplashDependencyFactory

import WalWalNetwork

import BaseCoordinator
import AppCoordinator
import AppCoordinatorImp

import SplashData
import SplashDataImp
import SplashDomain
import SplashDomainImp
import SplashPresenter
import SplashPresenterImp

public class SplashDependencyFactoryImp: SplashDependencyFactory {
  
  public init() {
    
  }
  
  public func makeAppCoordinator(navigationController: UINavigationController) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: nil,
      dependencyFactory: self
    )
  }
  
  public func makeSplashReactor(coordinator: any AppCoordinator) -> any SplashReactor {
    return SplashReactorImp(coordinator: coordinator)
  }
  
  public func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController {
    return SplashViewControllerImp(reactor: reactor)
  }
}
