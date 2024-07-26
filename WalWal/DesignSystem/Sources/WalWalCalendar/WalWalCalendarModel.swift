//
//  WalWalCalendarModel.swift
//  DesignSystem
//
//  Created by 조용인 on 7/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct WalWalCalendarModel {
  public let imageId: String
  public let date: String
  public let imageData: Data
  
  public init(
    imageId: String,
    date: String,
    imageData: Data
  ) {
    self.imageId = imageId
    self.date = date
    self.imageData = imageData
  }
}
