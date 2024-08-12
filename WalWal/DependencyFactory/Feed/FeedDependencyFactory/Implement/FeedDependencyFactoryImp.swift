//
//  FeedDependencyFactoryImplement.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import FeedDependencyFactory

import WalWalNetwork

import BaseCoordinator
import FeedCoordinator
import FeedCoordinatorImp

import FeedData
import FeedDataImp
import FeedDomain
import FeedDomainImp
import FeedPresenter
import FeedPresenterImp

public class FeedDependencyFactoryImp: FeedDependencyFactory {
  public init() { }
  
  public func makeFeedCoordinator(navigationController: UINavigationController, parentCoordinator: (any BaseCoordinator)?) -> any FeedCoordinator {
    return FeedCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      feedDependencyFactory: self
    )
  }
  
  public func makeFeedReactor<T>(coordinator: T) -> any FeedPresenter.FeedReactor where T : FeedCoordinator {
    return FeedReactorImp(
      coordinator: coordinator
    )
  }
  
  public func makeFeedViewController<T>(reactor: T) -> any FeedPresenter.FeedViewController where T : FeedPresenter.FeedReactor {
    return FeedViewControllerImp(reactor: reactor)
  }
}
