//
//  SceneDelegate.swift
//  WalWal
//
//  Created by 조용인 on 6/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let _ = (scene as? UIWindowScene) else { return }
    
    /// 여기도 InActive 상태일 때 처리하기 위한 함수 정의
    guard let notificationResponse = connectionOptions.notificationResponse else { return }
    let notification = notificationResponse.notification.request.content.userInfo
    handleNotification(userInfo: notification)
  }

  func handleNotification(userInfo: [AnyHashable: Any]) {
    /// 이 곳에서, Notification을 통해 받은 정보 처리함.
    /// ex) if let actionUrl = userInfo["action"] as? String {
    ///        let afterUrl = Setting.BASE_URL + actionUrl
    ///        UserDefaultManager.shared.save(afterUrl, for: .afterUrl)
    ///    }
  }
}

