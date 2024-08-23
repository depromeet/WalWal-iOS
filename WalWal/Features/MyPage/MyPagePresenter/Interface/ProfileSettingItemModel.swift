//
//  ProfileSettingItemModel.swift
//  MyPagePresenter
//
//  Created by Jiyeon on 8/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public struct ProfileSettingItemModel {
  public let title: String
  public let iconImage: UIImage?
  public let subTitle: String
  public let rightText: String
  public let type: SettingType
  
  public init(title: String,
              iconImage: UIImage?,
              subTitle: String,
              rightText: String,
              type: SettingType
  ) {
    self.title = title
    self.iconImage = iconImage
    self.subTitle = subTitle
    self.rightText = rightText
    self.type = type
  }
}

public enum SettingType {
  case logout
  case version
  case withdraw
}
