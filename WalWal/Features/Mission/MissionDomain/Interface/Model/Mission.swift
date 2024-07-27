//
//  Mission.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MissionModel {
  public let title: String
  public let isStartMission: Bool
  public let imageURL: String
  public let date: Int
  public let backgroundColorCode: String
  
  public init(title: String, isStartMission: Bool, imageURL: String, date: Int, backgroundColorCode: String) {
    self.title = title
    self.isStartMission = isStartMission
    self.imageURL = imageURL
    self.date = date
    self.backgroundColorCode = backgroundColorCode
  }
}
