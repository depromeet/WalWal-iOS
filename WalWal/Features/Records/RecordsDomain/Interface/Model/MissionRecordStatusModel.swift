//
//  MissionRecordStatusModel.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData

public struct MissionRecordStatusModel: Equatable, Hashable {
  public let imageUrl: String
  public let statusMessage: StatusMessage
  
  public init(dto: MissionRecordStatusDTO) {
    self.imageUrl = dto.imageUrl ?? ""
    self.statusMessage = StatusMessage(rawValue: dto.status) ?? .notCompleted
  }
  
  public static func == (lhs: MissionRecordStatusModel, rhs: MissionRecordStatusModel) -> Bool {
    return lhs.imageUrl == rhs.imageUrl 
    && lhs.statusMessage == rhs.statusMessage
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(imageUrl)
    hasher.combine(statusMessage)
  }
}

public enum StatusMessage: String, Equatable, Hashable {
  case notCompleted = "NOT_COMPLETED"
  case inProgress = "IN_PROGRESS"
  case completed = "COMPLETED"
  
  public var description: String {
    switch self {
    case .notCompleted:
      return "미션 시작하기"
    case .inProgress:
      return "남았어요!"
    case .completed:
      return "내 미션 기록 보기"
    }
  }
}
