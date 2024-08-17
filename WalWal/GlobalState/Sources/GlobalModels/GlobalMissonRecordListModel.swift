//
//  GlobalMissonRecordListModel.swift
//  GlobalState
//
//  Created by 조용인 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct GlobalMissonRecordListModel {
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
