//
//  MyPageDependencyFactoryImplement.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import MyPageDependencyFactory

import BaseCoordinator
import MyPageCoordinator
import MyPageCoordinatorImp

import MyPagePresenter
import MyPagePresenterImp

public class MyPageDependencyFactoryImp: MyPageDependencyFactory {
  
  public init() {
    
  }
  
  public func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?
  ) -> any MyPageCoordinator {
    return MyPageCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      myPageDependencyFactory: self
    )
  }
  
  public func makeMyPageReactor<T: MyPageCoordinator>(coordinator: T) -> any MyPageReactor {
    return MyPageReactorImp(
      coordinator: coordinator
    )
  }
  
  public func makeMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController {
    return MyPageViewControllerImp(reactor: reactor)
  }
  
  
}
