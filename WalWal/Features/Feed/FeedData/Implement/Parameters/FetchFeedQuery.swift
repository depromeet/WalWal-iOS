//
//  FetchFeedQuery.swift
//  FeedDataImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct FetchFeedQuery: Encodable {
  let cursor: String
  let limit: Int
}
