//
//  MissionInfoDTO.swift
//  MissionData
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MissionInfoDTO: Decodable {
  public let id: Int
  public let title: String
  public let illustrationURL: String
  
  enum CodingKeys: String, CodingKey {
    case id, title
    case illustrationURL = "illustrationUrl"
  }
}
