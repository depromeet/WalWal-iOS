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
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalFeed = self.list.map {
      GlobalFeedListModel(
        imageId: $0.missionRecordID,
        imageUrl: $0.missionRecordImageURL,
        missionDate: $0.createdDate
      )
    }
    
    globalState.updateFeed(with: globalFeed)
  }
}

