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
  public let missionTitle: String
  public let recordId: Int?
  public let records: [RecordList]
  
  public init(dto: MissionRecordStatusDTO, recordListDTO: [RecordDTO]) {
    self.imageUrl = dto.imageURL ?? ""
    self.statusMessage = StatusMessage(rawValue: dto.status) ?? .notCompleted
    self.missionTitle = dto.missionTitle
    self.recordId = dto.recordID
    self.records = recordListDTO.map{ record in
      RecordList(
        recordId: record.recordID,
        recordImageURL: record.imageURL,
        recordContent: record.content,
        missionTitle: record.missionTitle,
        missionIllustrationURL: record.illustrationURL,
        completedAt: record.completedAt
      )
    }
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

// 미션 완료 시 기록 리스트
public struct RecordList {
  public let recordId: Int
  public let recordImageURL: String
  public let recordContent: String
  public let missionTitle: String
  public let missionIllustrationURL: String
  public let completedAt: String
  
  public init(recordId: Int, recordImageURL: String, recordContent: String, missionTitle: String, missionIllustrationURL: String, completedAt: String) {
    self.recordId = recordId
    self.recordImageURL = recordImageURL
    self.recordContent = recordContent
    self.missionTitle = missionTitle
    self.missionIllustrationURL = missionIllustrationURL
    self.completedAt = completedAt
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
