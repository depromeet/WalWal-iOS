//
//  FeedModel.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import FeedData

public struct FeedModel {
  public let list: [FeedListModel]
  public let nextCursor: String?
  
  
  public init(dto: FeedDTO) {
    self.list = dto.list.map{ FeedListModel(dto: $0) }
    self.nextCursor = FeedNextCursorModel( dto: dto ).nextCursor
  }
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared, isFeed: Bool = true) {
    let globalFeed = self.list.map {
      GlobalFeedListModel(
        recordID: $0.missionRecordID,
        authorID: $0.authorID,
        createdDate: $0.createdDate,
        authorNickname: $0.authorNickName,
        missionTitle: $0.missionTitle,
        profileImage: $0.authorProfileImageURL,
        missionImage: $0.missionRecordImageURL,
        boostCount: $0.totalBoostCount,
        contents: $0.content
      )
    }
    if isFeed {
      globalState.updateFeed(with: globalFeed)
    } else {
      globalState.updateRecords(with: globalFeed)
    }
  }
}

