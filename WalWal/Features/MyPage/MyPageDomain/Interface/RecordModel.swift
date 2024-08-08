//
//  File.swift
//  MyPageDomainImp
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public struct RecordModel {
  var isFeedCell: Bool
  var date: String
  var nickname: String
  var missionTitle: String
  var profileImage: UIImage
  var missionImage: UIImage
  var boostCount: Int
  
  public init(
    isFeedCell: Bool,
    date: String,
    nickname: String,
    missionTitle: String,
    profileImage: UIImage,
    missionImage: UIImage,
    boostCount: Int
  ) {
    self.isFeedCell = isFeedCell
    self.date = date
    self.nickname = nickname
    self.missionTitle = missionTitle
    self.profileImage = profileImage
    self.missionImage = missionImage
    self.boostCount = boostCount
  }
}
