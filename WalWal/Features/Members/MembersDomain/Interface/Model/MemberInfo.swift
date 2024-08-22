//
//  ProfileInfo.swift
//  MembersDomain
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MembersData
import GlobalState
import ResourceKit

public struct MemeberInfo {
  public let memberId: Int
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  public var profileImage: UIImage?
  
  public init(global: GlobalProfileModel) {
    self.memberId = global.memberId
    self.nickname = global.nickname
    self.profileURL = global.profileURL
    self.raisePet = global.raisePet
    if let defaultProfile = DefaultProfile(rawValue: global.profileURL) {
      self.profileImage = defaultProfile.image
    } else {
      self.profileImage = GlobalState.shared.imageStore[global.profileURL]
    }
  }
  
  public init(dto: MemberDTO) {
    self.memberId = dto.memberId
    self.nickname = dto.nickname
    self.profileURL = dto.profileImageUrl
    self.raisePet = dto.raisePet
  }
  
  
  public func saveToGlobalState(globalState: GlobalState = GlobalState.shared) {
    let globalProfile = GlobalProfileModel(
      memberId: memberId,
      nickname: nickname,
      profileURL: profileURL,
      raisePet: raisePet
    )
    globalState.updateProfileInfo(data: globalProfile)
  }
  
}
