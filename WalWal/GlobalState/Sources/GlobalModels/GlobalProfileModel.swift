//
//  ProfileModel.swift
//  GlobalState
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct GlobalProfileModel {
  public let memberId: Int
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  
  public init(
    memberId: Int,
    nickname: String,
    profileURL: String,
    raisePet: String
  ) {
    self.memberId = memberId
    self.nickname = nickname
    self.profileURL = profileURL
    self.raisePet = raisePet
  }
}
