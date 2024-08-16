//
//  MemberURLDTO.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 회원프로필 이미지 Presigned URL 생성  Request DTO
public struct MemberUploadUrlDTO: Decodable {
  public let imageFileExtension: String
}
