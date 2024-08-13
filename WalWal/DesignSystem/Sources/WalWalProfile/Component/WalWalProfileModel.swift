//
//  WalWalProfileModel.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

/// 왈왈 프로필 이미지 정보
///
/// - Parameters:
///   - profileType: 왈왈 기본 이미지인지 앨범 선택 이미지인지 구분하기 위한 타입
///   - selectImage: 앨범에서 선택한 이미지 데이터
///   - defaultImage: 왈왈 기본이미지 데이터
public struct WalWalProfileModel: Equatable {
  public init(
    profileType: ProfileType,
    selectImage: UIImage? = nil,
    defaultImage: DefaultProfile? = nil
  ) {
    self.profileType = profileType
    self.selectImage = selectImage
    self.defaultImage = defaultImage
  }
  public var profileType: ProfileType
  public var selectImage: UIImage?
  public var defaultImage: DefaultProfile?
}

/// 프로필 사진 타입 열거형
public enum ProfileType {
  /// 기본 랜덤 이미지 타입
  case defaultImage
  /// 사용자 선택 이미지
  case selectImage
}
