//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit

import SplashDependencyFactoryImp
import AuthDependencyFactoryImp
import WalWalTabBarDependencyFactoryImp
import MissionDependencyFactoryImp
import MyPageDependencyFactoryImp
import AppCoordinator

import KakaoSDKCommon
import KakaoSDKAuth

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  /// 메모리에 계속 남아있을 수 있도록, 전역 변수로 만들어야함.... (여기서 시간 많이 날려써요 ㅠㅠㅠㅠ)
  var appCoordinator: (any AppCoordinator)?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    KakaoSDK.initSDK(appKey: "29e3431e2dc66a607f511c0a05f0963b")
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    /// 전체 의존성 구현체를 이곳에서 한번에 정의
    let splashDependencyFactory = SplashDependencyFactoryImp()
    let authDependencyFactory = AuthDependencyFactoryImp()
    let walwalTabBarDependencyFactory = WalWalTabBarDependencyFactoryImp()
    let missionDependencyFactory = MissionDependencyFactoryImp()
    let myPageDependencyFactory = MyPageDependencyFactoryImp()
    
    let navigationController = UINavigationController()
    
    /// 최상단 코디네이터인 AppCoordinator에 모든 의존성의 인터페이스 주입
    self.appCoordinator = splashDependencyFactory.makeAppCoordinator(
      navigationController: navigationController,
      authDependencyFactory: authDependencyFactory,
      walwalTabBarDependencyFactory: walwalTabBarDependencyFactory,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory
    )
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    appCoordinator?.start()
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    return false
  }
}

