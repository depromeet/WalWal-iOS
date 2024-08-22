//
//  GlobalFeedListModel.swift
//  GlobalState
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
public struct GlobalFeedListModel {
  public let recordID: Int
  public let createdDate: String
  public let authorNickname: String
  public let missionTitle: String
  public let profileImage: String?
  public let missionImage: String?
  public let boostCount: Int
  
  public init(
    recordID: Int,
    createdDate: String,
    authorNickname: String,
    missionTitle: String,
    profileImage: String?,
    missionImage: String?,
    boostCount: Int
  ) {
    self.recordID = recordID
    self.createdDate = createdDate
    self.authorNickname = authorNickname
    self.missionTitle = missionTitle
    self.profileImage = profileImage
    self.missionImage = missionImage
    self.boostCount = boostCount
  }
}
