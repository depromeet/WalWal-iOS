//
//  ProfileInfo.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageData

public struct ProfileInfo {
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  
  public init(dto: MemberDTO) {
    self.nickname = dto.profile.nickname
    self.profileURL = dto.profile.profileImageUrl
    self.raisePet = dto.raisePet
  }
  
}
