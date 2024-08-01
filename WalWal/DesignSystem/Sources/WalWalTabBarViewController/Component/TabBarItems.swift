//
//  TabBarItems.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

public enum TabBarItem: Int, CaseIterable {
  case mission
  case feed
  case notification
  case mypage
  
  var icon: UIImage {
    switch self {
    case .mission: return ResourceKitAsset.Assets.flagLight.image
    case .feed: return ResourceKitAsset.Assets.giftLight.image
    case .notification: return ResourceKitAsset.Assets.locationLight.image
    case .mypage: return ResourceKitAsset.Assets.imageLight.image
    }
  }
  
  var selectedIcon: UIImage {
    switch self {
    case .mission: return ResourceKitAsset.Assets.flagFilled.image
    case .feed: return ResourceKitAsset.Assets.giftFilled.image
    case .notification: return ResourceKitAsset.Assets.locationFilled.image
    case .mypage: return ResourceKitAsset.Assets.imageFilled.image
    }
  }
  
  var title: String {
    switch self {
    case .mission: return "미션"
    case .feed: return "피드"
    case .notification: return "알림"
    case .mypage: return "마이"
    }
  }
}
