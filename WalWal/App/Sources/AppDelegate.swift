//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit
import AppCoordinator

import RxSwift
import RxCocoa
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var appCoordinator: (any AppCoordinator)?
  private let fcmToken = PublishRelay<String>()
  private let callBackDeepLink = PublishRelay<String>()
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    
    configure(application)
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let navigationController = UINavigationController()
    
    self.appCoordinator = self.injectWalWalImplement(navigation: navigationController)
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

private extension AppDelegate {
  func requestAuthorization() {
      UNUserNotificationCenter.current().delegate = self
      
//      let authOptions: UNAuthorizationOptions = [
//          .alert,
//          .badge,
//          .sound
//      ]
//      UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions,
//          completionHandler: { _, _ in }
//      )
  }

  func getFCMToken() {
    Messaging.messaging().token { token, error in
      if let error = error {
        print("🤖 Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("🤖 FCM registration token: \(token)")
        // TODO: - 여기서 FCM토큰 Local에 저장 (UserDefault)
      }
    }
  }
  
  func configure(_ application: UIApplication) {
    /// 알림 등록
    requestAuthorization()
    /// KakaoSDK 등록
    KakaoSDK.initSDK(appKey: "29e3431e2dc66a607f511c0a05f0963b")
    /// APNS에 Device Token 등록
    application.registerForRemoteNotifications()
    /// Firebase설정
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
  }
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
  /// APNs 등록 및 토큰 콜백
  func application(
    application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    /// APNs토큰 세팅
    Messaging.messaging().apnsToken = deviceToken
    /// 토큰 값 콜백
    getFCMToken()
  }
  
  /// 일반적으로 앱 시작 시 등록토큰을 통해, FCM Token 관찰
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    guard let fcmToken else { return }
    // TODO: - 여기서 FCM토큰 Local에 저장 (UserDefault)
    self.fcmToken.accept(fcmToken)
  }
  
  /// 앱이 inActive 상태일 때, 어떤 형식으로 notification을 보여줄지 설정 (인액티브 상태에서 보이기 싫으면 세팅 안해도 됨)
  /// 현재 상태는, [배너에 뱃지 타입으로 소리와 함께 노티를 보낸다] 라는 의미임
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .badge]
  }
  
  /// 앱이 suspend 상태일 때, 배너를 눌렀을 때의 처리 (네비게이션 루트 세팅 해야함 -> urlScheme)
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    /// let userInfo = response.notification.request.content.userInfo
    /// let urlScheme = userInfo["urlScheme"]
    /// callBackDeepLink.accept(urlScheme)
  }
  
}

