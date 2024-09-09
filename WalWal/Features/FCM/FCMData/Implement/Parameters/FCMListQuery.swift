//
//  FCMListQuery.swift
//  FCMDataImp
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct FCMListQuery: Encodable {
  let cursor: String?
  let limit: Int
}
