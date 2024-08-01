//
//  WalWalFeedModel.swift
//  DesignSystem
//
//  Created by 이지희 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public struct WalWalFeedModel {
  var nickname: String
  var missionTitle: String
  var profileImage: UIImage
  var missionImage: UIImage
  var boostCount: Int
  
  public init(
    nickname: String,
    missionTitle: String,
    profileImage: UIImage,
    missionImage: UIImage,
    boostCount: Int
  ) {
    self.nickname = nickname
    self.missionTitle = missionTitle
    self.profileImage = profileImage
    self.missionImage = missionImage
    self.boostCount = boostCount
  }
}

