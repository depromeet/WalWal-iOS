//
//  PresignedURLDTO.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// Presigned URL Response DTO
public struct PresignedURLDTO: Decodable {
  public let presignedUrl: String
}
