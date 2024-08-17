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
  public let imageId: Int
  public let date: String
  public let image: UIImage?
  
  public init(
    imageId: Int,
    date: String,
    image: UIImage?
  ) {
    self.imageId = imageId
    self.date = date
    self.image = image
  }

  public static func ==(
    lhs: WalWalCalendarModel,
    rhs: WalWalCalendarModel
  ) -> Bool {
    return lhs.imageId == rhs.imageId &&
    lhs.date == rhs.date &&
    lhs.image == rhs.image
  }
}
