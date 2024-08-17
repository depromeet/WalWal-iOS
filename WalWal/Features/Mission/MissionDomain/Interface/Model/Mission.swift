//
//  Mission.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MissionModel {
  public let id: Int
  public let title: String
  public let imageURL: String
  
  public init(
    id: Int,
    title: String,
    imageURL: String
  ) {
    self.id = id
    self.title = title
    self.imageURL = imageURL
  }
}
