//
//  WalWalProfileModel.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public struct WalWalProfileModel: Equatable {
  public init(profileType: ProfileType, curImage: UIImage? = nil, defaultImage: String? = nil) {
    self.profileType = profileType
    self.curImage = curImage
    self.defaultImage = defaultImage
  }
  public var profileType: ProfileType
  public var curImage: UIImage?
  public var defaultImage: String?
}

/// 프로필 사진 타입 열거형
public enum ProfileType {
  /// 기본 랜덤 이미지 타입
  case defaultImage
  /// 사용자 선택 이미지
  case selectImage
}
