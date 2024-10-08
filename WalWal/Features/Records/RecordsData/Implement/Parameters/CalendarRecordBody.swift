//
//  CalendarRecordBody.swift
//  RecordsDataImp
//
//  Created by 조용인 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct CalendarRecordQuery: Encodable {
  let cursor: String
  let limit: Int
  let memberId: Int?
}
