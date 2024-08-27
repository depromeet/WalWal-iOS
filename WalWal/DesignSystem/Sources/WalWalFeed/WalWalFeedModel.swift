//
//  WalWalFeedModel.swift
//  DesignSystem
//
//  Created by 이지희 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public struct WalWalFeedModel: Equatable {
  public let recordId: Int
  var authorId: Int
  var date: String
  var nickname: String
  var missionTitle: String
  var profileImage: UIImage?
  var missionImage: UIImage?
  var boostCount: Int
  var contents: String
  
  public init(
    recordId: Int,
    authorId: Int,
    date: String,
    nickname: String,
    missionTitle: String,
    profileImage: UIImage?,
    missionImage: UIImage?,
    boostCount: Int,
    contents: String
  ) {
    self.recordId = recordId
    self.authorId = authorId
    self.date = date
    self.nickname = nickname
    self.missionTitle = missionTitle
    self.profileImage = profileImage
    self.missionImage = missionImage
    self.boostCount = boostCount
    self.contents = contents
  }
  
  public static func ==(
    lhs: WalWalFeedModel,
    rhs: WalWalFeedModel
  ) -> Bool {
    return lhs.recordId == rhs.recordId
  }
}

