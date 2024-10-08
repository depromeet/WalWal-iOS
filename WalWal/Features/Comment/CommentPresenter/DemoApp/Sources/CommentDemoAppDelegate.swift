//
//  CommentAppDelegate.swift
//
//  Comment
//
//  Created by 조용인 on .
//

import UIKit

import CommentDependencyFactory
import CommentDependencyFactoryImp
import CommentData
import CommentDomain
import CommentPresenter

import WalWalNetwork
import CommentDataImp
import CommentDomainImp
import CommentPresenterImp

@main
final class CommentAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = CommentDependencyFactoryImp()
    let navigationController = UINavigationController()
    
    let reactor = CommentReactorImp(
      getCommentsUsecase: GetCommentsUsecaseImp(
        repository: CommentRepositoryImp(
          networkService: NetworkService()
        )
      ),
      postCommentUsecase: PostCommentUsecaseImp(
        repository: CommentRepositoryImp(
          networkService: NetworkService()
        )
      ),
      flattenCommentUsecase: FlattenCommentsUsecaseImp()
    )
    let viewController = CommentViewControllerImp(reactor: reactor)
    
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}


