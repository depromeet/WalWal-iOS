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
  public let memberId: Int
  public let nickname: String
  public let profileURL: String
  public let raisePet: String
  public var profileImage: UIImage?
  public var defaultImageName: String?
  
  public init(global: GlobalProfileModel) {
    self.memberId = global.memberId
    self.nickname = global.nickname
    self.profileURL = global.profileURL
    self.raisePet = global.raisePet
    if let defaultProfile = DefaultProfile(rawValue: global.profileURL) {
      defaultImageName = defaultProfile.rawValue
    } else {
      self.profileImage = GlobalState.shared.imageStore[global.profileURL]
    }
  }
  
  public init(memberId: Int, nickName: String, profileURL: String, raisePet: String){
    self.memberId = memberId
    self.nickname = nickName
    self.profileURL = profileURL
    self.raisePet = raisePet
  }
}
