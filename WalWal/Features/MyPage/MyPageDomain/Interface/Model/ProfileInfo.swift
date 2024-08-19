//
//  ProfileInfo.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageData
import GlobalState

public struct ProfileInfo {
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  
  public init(global: GlobalProfileModel) {
    self.nickname = global.nickname
    self.profileURL = global.profileURL
    self.raisePet = global.raisePet
  }
  
  public init(dto: MemberDTO) {
    self.nickname = dto.profile.nickname
    self.profileURL = dto.profile.profileImageUrl
    self.raisePet = dto.raisePet
  }
  
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalProfile = GlobalProfileModel(
      nickname: nickname,
      profileURL: profileURL,
      raisePet: raisePet
    )
    globalState.updateProfileInfo(data: globalProfile)
  }
  
}
