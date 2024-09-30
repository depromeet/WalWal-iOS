//
//  AppUpdataManager.swift
//  Utility
//
//  Created by 조용인 on 9/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit

public final class AppUpdateManager {
  
  public static let shared = AppUpdateManager()
  
  private init() {}
  
  public func checkForUpdate() {
    guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
      print("Failed to get the current version.")
      return
    }
    guard let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
      print("Failed to get the current version.")
      return
    }
    fetchAppStoreVersion(bundleID: bundleId) { [weak self] appStoreVersion in
      guard let self = self, let appStoreVersion = appStoreVersion else {
        print("Failed to fetch the App Store version.")
        return
      }
      
      DispatchQueue.main.async {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
        let isNewVersionAvailable = currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
        if isNewVersionAvailable {
          self.showUpdateAlert(viewController: window.rootViewController, newVersion: appStoreVersion)
        }
      }
    }
  }
  
  private func fetchAppStoreVersion(bundleID: String, completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        completion(nil)
        return
      }
      
      do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let results = json["results"] as? [[String: Any]],
           let appStoreVersion = results.first?["version"] as? String {
          completion(appStoreVersion)
        } else {
          completion(nil)
        }
      } catch {
        completion(nil)
      }
    }
    task.resume()
  }
  
  private func showUpdateAlert(viewController: UIViewController?, newVersion: String) {
    let title = "업데이트"
    let message = "왈왈의 새 버전이 업데이트되었습니다.\n더 좋은 서비스 이용을 위해 \(newVersion)(으)로 업데이트 해주세요."
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let updateAction = UIAlertAction(title: "지금 업데이트", style: .default) { _ in
      var country = "kr"
      if #available(iOS 16.0, *){ country = NSLocale.current.language.region!.identifier }
      guard let url = URL(string: "https://apps.apple.com/\(country)/app/%EC%99%88%EC%99%88/id6553981069") else {
        return
      }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    let cancelAction = UIAlertAction(title: "나중에", style: .cancel) { _ in }
    alert.addAction(updateAction)
    alert.addAction(cancelAction)
    
    viewController?.present(alert, animated: true)
  }
}
