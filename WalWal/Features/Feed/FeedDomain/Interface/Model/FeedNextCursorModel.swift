//
//  FeedNextCursorModel.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import FeedData

public struct FeedNextCursorModel {
  var nextCursor: String?
  
  init(dto: FeedDTO) {
    nextCursor = dto.nextCursor
  }
}
