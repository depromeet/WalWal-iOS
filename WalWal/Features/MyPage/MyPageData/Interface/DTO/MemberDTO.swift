//
//  MemberDTO.swift
//  MyPageData
//
//  Created by Jiyeon on 8/18/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MemberDTO: Decodable {
  public let profile: ProfileDTO
  public let raisePet: String
}

public struct ProfileDTO: Decodable {
  public let nickname: String
  public let profileImageUrl: String
}
