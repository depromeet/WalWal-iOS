//
//  FCMDeepLinkManager.swift
//  WalWal
//
//  Created by Jiyeon on 9/8/24.
//

import Foundation
import AppCoordinator
import GlobalState

final class FCMDeepLinkManager {
  static let shared = FCMDeepLinkManager()
  private init() { }
  
  func checkDeepLink(userInfo: [AnyHashable : Any], coordinator: (any AppCoordinator)?) {
    guard let deepLinkUrl = userInfo["deepLink"] as? String,
            let url = URL(string: deepLinkUrl) else { return }
    
    guard let type = url.host else { return }
    
    switch DeepLinkTarget(rawValue: type) {
    case .mission:
      coordinator?.pushTabMove(to: .mission)
    case .booster:
      decodeDeepLinkUrl(url: url)
      coordinator?.pushTabMove(to: .feed)
    default:
      break
    }
  }
  
  private func decodeDeepLinkUrl(url: URL) {
    let urlString = url.absoluteString
    guard urlString.contains("id") else { return }
    
    let components = URLComponents(string: urlString)
    let urlQueryItems = components?.queryItems ?? []
    var dictionaryData = [String: String]()
    urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }
    guard let recordId = dictionaryData["id"] else { return }
    
    GlobalState.shared.updateRecordId(Int(recordId))
  }
}

enum DeepLinkTarget: String {
  case mission = "Mission"
  case booster = "Booster"
}
