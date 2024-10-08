//
//  AppDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit
import AppCoordinator
import LocalStorage

import RxSwift
import RxCocoa
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging
import FirebaseCrashlytics

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var appCoordinator: (any AppCoordinator)?
  private let fcmToken = PublishRelay<String>()
  private let receiveDeepLink = BehaviorRelay<String?>(value: nil)
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    configure(application)
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let navigationController = UINavigationController()
    
    
    self.appCoordinator = self.injectWalWalImplement(
      navigation: navigationController,
      deepLinkObservable: receiveDeepLink.asObservable()
    )
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    
    if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any],
       let deepLink = userInfo["deepLink"] as? String {
      UserDefaults.setValue(value: true, forUserDefaultKey: .enterDeepLink)
      receiveDeepLink.accept(deepLink)
    }
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
  
  func getFCMToken() {
    Messaging.messaging().token { token, error in
      if let error = error {
        print("🤖 Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("🤖 FCM registration token: \(token)")
        UserDefaults.setValue(value: token, forUserDefaultKey: .notification)
      }
    }
  }
  
  func configure(_ application: UIApplication) {
    /// Firebase설정
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self
    
    /// APNS에 Device Token 등록
    application.registerForRemoteNotifications()
    /// KakaoSDK 등록
    let KakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as? String ?? ""
    KakaoSDK.initSDK(appKey: KakaoAppKey)
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
    print("didRegisterForRemoteNotificationsWithDeviceToken 호출")
  }
  
  /// 일반적으로 앱 시작 시 등록토큰을 통해, FCM Token 관찰
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    guard let fcmToken else { return }
    print("didReceiveRegistrationToken 호출")
    print("토큰 주세요 :: \(fcmToken)")
    UserDefaults.setValue(value: fcmToken, forUserDefaultKey: .notification)
    self.fcmToken.accept(fcmToken)
  }
  
  /// 앱이 inActive 상태일 때, 어떤 형식으로 notification을 보여줄지 설정 (인액티브 상태에서 보이기 싫으면 세팅 안해도 됨)
  /// 현재 상태는, [배너에 뱃지 타입으로 소리와 함께 노티를 보낸다] 라는 의미임
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    print("willPresent")
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    return [.banner, .sound, .badge]
  }
  
  /// 앱이 suspend 상태일 때, 배너를 눌렀을 때의 처리 (네비게이션 루트 세팅 해야함 -> urlScheme)
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    print("didReceive")
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    let userInfo = response.notification.request.content.userInfo
    guard let deepLink = userInfo["deepLink"] as? String else { return }
    
    UserDefaults.setValue(value: true, forUserDefaultKey: .enterDeepLink)
    receiveDeepLink.accept(deepLink)
  }
}

