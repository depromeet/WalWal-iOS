//
//  MissionRecordStatusDTO.swift
//  RecordsData
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MissionRecordStatusDTO: Codable {
  public let recordId: Int
  public let imageUrl: String
  public let status: String
}
