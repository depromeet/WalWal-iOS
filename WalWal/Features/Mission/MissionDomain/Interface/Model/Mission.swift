//
//  Mission.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import MissionData

public struct MissionModel {
  public let id: Int
  public let title: String
  public let imageURL: String
  
  public init(dto: MissionInfoDTO) {
    self.id = dto.id
    self.title = dto.title
    self.imageURL = dto.illustrationURL
  }
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalTodayMission = GlobalTodayMissionModel(
      missionId: id,
      missionTitle: title,
      missionImage: imageURL
    )
    
    globalState.updateTodayMission(with: globalTodayMission)
  }
}
