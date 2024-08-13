//
//  DefaultProfile.swift
//  ResourceKit
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 왈왈 기본 프로필 이미지 데이터
///
/// 색깔_타입 으로 구성(타입: Dog or Cat)
///
/// 케이스의 rawvalue는 서버에 기본 이미지 값을 전송하기 위한 값 ex) "profileImageUrl": "YELLOW_DOG"
///
/// 이후 서버에서 받은 값을 rawvalue를 통해 이미지를 찾을 수 있음
///
/// `DefaultProfile(rawValue: "YELLOW_DOG")`
public enum DefaultProfile: String, Equatable {
  case yellowDog = "YELLOW_DOG"
  case pinkDog = "PINK_DOG"
  case greenDog = "GREEN_DOG"
  case skyDog = "SKY_DOG"
  case blueDog = "BLUE_DOG"
  case purpleDog = "PURPLE_DOG"
  
  case yellowCat = "YELLOW_CAT"
  case pinkCat = "PINK_CAT"
  case greenCat = "GREEN_CAT"
  case skyCat = "SKY_CAT"
  case blueCat = "BLUE_CAT"
  case purpleCat = "PURPLE_CAT"
  
  /// DefaultProfile 케이스에 대한 이미지 정보
  public var image: ResourceKitImages.Image {
    switch self {
    case .yellowDog:
      return ResourceKitAsset.Assets.yellowDog.image
    case .pinkDog:
      return ResourceKitAsset.Assets.pinkDog.image
    case .greenDog:
      return ResourceKitAsset.Assets.greenDog.image
    case .skyDog:
      return ResourceKitAsset.Assets.skyDog.image
    case .blueDog:
      return ResourceKitAsset.Assets.blueDog.image
    case .purpleDog:
      return ResourceKitAsset.Assets.purpleDog.image
    
    // TODO: - 고양이 이미지 수정 필요
    case .yellowCat:
      return ResourceKitAsset.Assets.yellowDog.image
    case .pinkCat:
      return ResourceKitAsset.Assets.pinkDog.image
    case .greenCat:
      return ResourceKitAsset.Assets.greenDog.image
    case .skyCat:
      return ResourceKitAsset.Assets.skyDog.image
    case .blueCat:
      return ResourceKitAsset.Assets.blueDog.image
    case .purpleCat:
      return ResourceKitAsset.Assets.purpleDog.image
      
    }
  }
  
  /// Dog 케이스 배열
  ///
  /// 사용예시:
  /// ```swift
  /// var index = 1
  /// imageView.image = DefaultProfile.defaultDogs[index].image
  /// var rawValue = DefaultProfile.defaultDogs[index].rawValue
  /// ```
  public static var defaultDogs: [DefaultProfile] {
    return [DefaultProfile.yellowDog, DefaultProfile.pinkDog, DefaultProfile.greenDog, DefaultProfile.skyDog, DefaultProfile.blueDog, DefaultProfile.purpleDog]
  }
  
  /// Cat 케이스 배열
  ///
  /// 사용예시:
  /// ```swift
  /// var index = 1
  /// imageView.image = DefaultProfile.defaultCats[index].image
  /// var rawValue = DefaultProfile.defaultCats[index].rawValue
  /// ```
  public static var defaultCats: [DefaultProfile] {
    return [DefaultProfile.yellowCat, DefaultProfile.pinkCat, DefaultProfile.greenCat, DefaultProfile.skyCat, DefaultProfile.blueCat, DefaultProfile.purpleCat]
  }
}

