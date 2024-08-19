//
//  ProfileModel.swift
//  GlobalState
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct GlobalProfileModel {
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  
  public init(
    nickname: String,
    profileURL: String,
    raisePet: String
  ) {
    self.nickname = nickname
    self.profileURL = profileURL
    self.raisePet = raisePet
  }
}
