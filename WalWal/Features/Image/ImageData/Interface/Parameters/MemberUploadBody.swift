//
//  MemberUploadBody.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 회원프로필 이미지 업로드 완료 Request Body
public struct MemberUploadBody: Encodable {
  public let imageFileExtension: String
  public let nickname: String
  
  public init(imageFileExtension: String, nickname: String) {
    self.imageFileExtension = imageFileExtension
    self.nickname = nickname
  }
}
