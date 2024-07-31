//
//  ProfileCellModel.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/28/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

/// ProfileSelectCollectionView에 들어가기 위한 셀 데이터 모델
struct ProfileCellModel {
  var profileType: ProfileType
  var curImage: UIImage?
}

/// 프로필 사진 타입 열거형
enum ProfileType {
  /// 기본 랜덤 이미지 타입
  case defaultImage
  /// 사용자 선택 이미지
  case selectImage
}
