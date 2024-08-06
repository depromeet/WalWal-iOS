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
  
  private typealias Color = ResourceKitAsset.Colors
  private typealias Image = ResourceKitAsset.Images
  
  case mission
  case feed
  case notification
  case mypage
  
  var icon: UIImage {
    switch self {
    case .mission: return Image.flagL.image.withTintColor(Color.gray300.color)
    case .feed: return Image.feedL.image.withTintColor(Color.gray300.color)
    case .notification: return Image.noticeL.image.withTintColor(Color.gray300.color)
    case .mypage: return Image.profileL.image.withTintColor(Color.gray300.color)
    }
  }
  
  var selectedIcon: UIImage {
    switch self {
    case .mission: return Image.flagL.image.withTintColor(Color.black.color)
    case .feed: return Image.feedL.image.withTintColor(Color.black.color)
    case .notification: return Image.noticeL.image.withTintColor(Color.black.color)
    case .mypage: return Image.profileL.image.withTintColor(Color.black.color)
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
