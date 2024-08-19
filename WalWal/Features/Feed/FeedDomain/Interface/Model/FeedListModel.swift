//
//  FeedListModel.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import FeedData

public struct FeedListModel {
  public let missionID, missionRecordID, authorID: Int
  public let missionRecordImageURL, createdDate: String
  public let totalBoostCount: Int
  public let content: String
  
  public init(dto: FeedListDTO) {
    self.missionID = dto.missionID
    self.missionRecordID = dto.missionRecordID
    self.authorID = dto.authorID
    self.missionRecordImageURL = dto.missionRecordImageURL
    self.createdDate = dto.createdDate
    self.totalBoostCount = dto.totalBoostCount
    self.content = dto.content
  }
}