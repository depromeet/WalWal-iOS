//
//  MemberURLBody.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 회원프로필 이미지 Presigned URL 생성  Request Body
public struct MemberUploadUrlBody: Encodable {
  public let imageFileExtension: String
  
  public init(imageFileExtension: String) {
    self.imageFileExtension = imageFileExtension
  }
}
