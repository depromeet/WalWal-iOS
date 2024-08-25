//
//  Mission.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MissionData

public struct MissionModel: Equatable, Hashable {
  public let id: Int
  public let title: String
  public let imageURL: String
  
  public init(dto: MissionInfoDTO) {
    self.id = dto.id
    self.title = dto.title
    self.imageURL = dto.illustrationURL
  }
  
  public static func == (lhs: MissionModel, rhs: MissionModel) -> Bool {
    return lhs.id == rhs.id 
    && lhs.title == rhs.title
    && lhs.imageURL == rhs.imageURL
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(title)
    hasher.combine(imageURL)
  }
}
