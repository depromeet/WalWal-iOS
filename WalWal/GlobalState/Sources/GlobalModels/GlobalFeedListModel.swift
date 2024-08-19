//
//  GlobalFeedListModel.swift
//  GlobalState
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
public struct GlobalFeedListModel {
  public let imageId: Int
  public let imageUrl: String
  public let missionDate: String
  
  public init(
    imageId: Int,
    imageUrl: String,
    missionDate: String
  ) {
    self.imageId = imageId
    self.imageUrl = imageUrl
    self.missionDate = missionDate
  }
}
