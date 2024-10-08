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
import MissionUploadDependencyFactory
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory
import MembersDependencyFactory
import ImageDependencyFactory
import CommentDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator
import WalWalTabBarCoordinatorImp

import RxSwift

public class WalWalTabBarDependencyFactoryImp: WalWalTabBarDependencyFactory {
  
  public init() {
    
  }
  
  public func makeTabBarCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory,
    deepLinkObservable: Observable<String?>
  ) -> any WalWalTabBarCoordinator {
    return WalWalTabBarCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      walwalTabBarDependencyFactory: self,
      missionDependencyFactory: missionDependencyFactory,
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      recordDependencyFactory: recordDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      membersDependencyFactory: membersDependencyFactory,
      commentDependencyFactory: commentDependencyFactory,
      deepLinkObservable: deepLinkObservable
    )
  }
  
}
