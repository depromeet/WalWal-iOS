//
//  GlobalMissionModel.swift
//  GlobalState
//
//  Created by 이지희 on 8/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct GlobalMissionStatusModel {
  let recordId: Int
  let missionStatus: String
  let recordImage: String
  
  public init(
    recordId: Int,
    missionStatus: String,
    recordImage: String
  ) {
    self.recordId = recordId
    self.missionStatus = missionStatus
    self.recordImage = recordImage
  }
}

public struct GlobalTodayMissionModel {
  let missionId: Int
  let missionTitle: String
  let missionImage: String
  
  public init(
    missionId: Int,
    missionTitle: String,
    missionImage: String
  ) {
    self.missionId = missionId
    self.missionTitle = missionTitle
    self.missionImage = missionImage
  }
}
