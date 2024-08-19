//
//  ToastType.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

/// 토스트 타입
public enum ToastType {
  case check
  case error
  case boost
  case mission
  
  /// 좌측 아이콘
  var icon: UIImage {
    switch self {
    case .check:
      return ResourceKitAsset.Images.check.image
    case .error:
      return ResourceKitAsset.Images.error.image
    case .boost:
      return ResourceKitAsset.Images.boost.image
    case .mission:
      return ResourceKitAsset.Images.mission.image
    }
  }
  
  /// 기본 설정 토스트 메세지 내용
  var message: String {
    switch self {
    case .check:
      return "피드에 업로드 완료했어요!"
    case .error:
      return "네트워크 연결이 불안정해요!"
    case .boost:
      return "부스터는 최대 500개 까지만 가능해요!"
    case .mission:
      return "미션을 완료했어요!"
    }
  }
  
}
