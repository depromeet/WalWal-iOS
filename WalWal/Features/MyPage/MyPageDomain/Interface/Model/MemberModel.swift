//
//  MemberModel.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import GlobalState
import ResourceKit

public struct MemberModel {
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  public var profileImage: UIImage?
  
  public init(global: GlobalProfileModel) {
    self.nickname = global.nickname
    self.profileURL = global.profileURL
    self.raisePet = global.raisePet
    if let defaultProfile = DefaultProfile(rawValue: global.profileURL) {
      self.profileImage = defaultProfile.image
    } else {
      self.profileImage = GlobalState.shared.imageStore[global.profileURL]
    }
  }
}
