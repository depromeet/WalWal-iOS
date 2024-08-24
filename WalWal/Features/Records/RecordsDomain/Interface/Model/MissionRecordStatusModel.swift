//
//  MissionRecordStatusModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import RecordsData

public struct MissionRecordStatusModel {
  public let recordId: Int
  public let imageUrl: String
  public let statusMessage: StatusMessage
  
  public init(dto: MissionRecordStatusDTO) {
    self.recordId = dto.recordId ?? 0
    self.imageUrl = dto.imageUrl ?? ""
    self.statusMessage = StatusMessage(rawValue: dto.status) ?? .notCompleted
  }
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalMissionStatus = GlobalMissionStatusModel(
      recordId: recordId,
      missionStatus: statusMessage.rawValue,
      recordImage: imageUrl
    )
    
    globalState.updateMissionStatus(with: globalMissionStatus)
  }
}

public enum StatusMessage: String {
  case notCompleted = "NOT_COMPLETED"
  case inProgress = "IN_PROGRESS"
  case completed = "COMPLETED"
  
  public var description: String {
    switch self {
    case .notCompleted:
      return "Not Completed"
    case .inProgress:
      return "In Progress"
    case .completed:
      return "Completed"
    }
  }
}
