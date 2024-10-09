//
//  AppUpdataManager.swift
//  Utility
//
//  Created by 조용인 on 9/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import RxSwift

public final class AppUpdateManager {
  
  public static let shared = AppUpdateManager()
  public private(set) var updateRequest = PublishSubject<Bool>()
  
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
        self.updateRequest.onNext(isNewVersionAvailable)
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
  
}
