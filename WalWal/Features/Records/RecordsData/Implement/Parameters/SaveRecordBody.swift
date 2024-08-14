//
//  SaveRecordBody.swift
//  RecordsDataImp
//
//  Created by 조용인 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct SaveRecordBody: Codable {
  let missionId: Int
  let content: String
}
