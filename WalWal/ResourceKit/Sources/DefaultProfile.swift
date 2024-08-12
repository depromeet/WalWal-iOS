//
//  DefaultProfile.swift
//  ResourceKit
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public enum DefaultProfile: String {
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
  public static var defaultDogs: [DefaultProfile] {
    return [DefaultProfile.yellowDog, DefaultProfile.pinkDog, DefaultProfile.greenDog, DefaultProfile.skyDog, DefaultProfile.blueDog, DefaultProfile.purpleDog]
  }
  public static var defaultCat: [DefaultProfile] {
    return [DefaultProfile.yellowCat, DefaultProfile.pinkCat, DefaultProfile.greenCat, DefaultProfile.skyCat, DefaultProfile.blueCat, DefaultProfile.purpleCat]
  }
}

