//
//  MembersRepository.swift
//  MembersData
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol MembersRepository {
  func profileInfo() -> Single<MemberDTO>
  func checkValidNickname(nickname: String) -> Single<Void>
  func editProfile(nickname: String, profileImage: String) -> Single<Void>
}
