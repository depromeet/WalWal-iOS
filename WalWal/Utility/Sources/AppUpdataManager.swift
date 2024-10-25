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
  public private(set) var updateRequest = PublishSubject<Void>()
  
  private init() {}
  
  public func checkForUpdate() {
    Task {
      guard
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
        let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
        let appStoreVersion = await fetchAppStoreVersion(bundleID: bundleId)
      else {
        print("최신 앱 버전 / 현재 앱 버전을 가져오는데 실패했습니다. 😵")
        return
      }
      
      if appStoreVersion > currentVersion { updateRequest.onNext(()) }
    }
  }
  
  private func fetchAppStoreVersion(bundleID: String) async -> String? {
    let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)")!
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
         let results = json["results"] as? [[String: Any]],
         let appStoreVersion = results.first?["version"] as? String {
        return appStoreVersion
      } else { return nil }
    } catch { return nil }
  }
}
