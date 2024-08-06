//
//  ProfileCellModel.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

/// ProfileSelectCollectionView에 들어가기 위한 셀 데이터 모델
public struct ProfileCellModel: Equatable {
  public init(profileType: ProfileType, curImage: UIImage? = nil) {
    self.profileType = profileType
    self.curImage = curImage
  }
  public var profileType: ProfileType
  public var curImage: UIImage?
}

/// 프로필 사진 타입 열거형
public enum ProfileType {
  /// 기본 랜덤 이미지 타입
  case defaultImage
  /// 사용자 선택 이미지
  case selectImage
}
