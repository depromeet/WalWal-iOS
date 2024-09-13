//
//  MemberDTO.swift
//  MembersData
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct MemberDTO: Decodable {
  public let memberId: Int
  public let nickname: String
  public let profileImageUrl: String?
  public let raisePet: String
}
