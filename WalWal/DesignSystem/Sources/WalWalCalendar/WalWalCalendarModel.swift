//
//  WalWalCalendarModel.swift
//  DesignSystem
//
//  Created by 조용인 on 7/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit

public struct WalWalCalendarModel: Equatable {
  public let recordId: Int
  public let date: String
  public let image: UIImage?
  
  public init(
    recordId: Int,
    date: String,
    image: UIImage?
  ) {
    self.recordId = recordId
    self.date = date
    self.image = image
  }

  public static func ==(
    lhs: WalWalCalendarModel,
    rhs: WalWalCalendarModel
  ) -> Bool {
    return lhs.recordId == rhs.recordId &&
    lhs.date == rhs.date &&
    lhs.image == rhs.image
  }
}
