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
import LocalStorage

@main
final class CommentAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let dependencyFactory = CommentDependencyFactoryImp()
    let navigationController = UINavigationController()
    
//    let _ = KeychainWrapper.shared.setAccessToken("eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFM1MTIiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzI4MzU1MTI3OTM0fQ.eyJzdWIiOiI1MyIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzI4MzU1MTI3LCJleHAiOjE3Mjg0NDE1Mjd9.6RXowt3yIV_m4EfQzBAmSDunv1cEPIgSH7UKx146sMgHrQY0r4rc0SXHtzu1Bhq4E0e44PafOACMcCjM1raXDA")
//    UserDefaults.setValue(value: <#T##Any?#>, forUserDefaultKey: .refreshToken)
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


