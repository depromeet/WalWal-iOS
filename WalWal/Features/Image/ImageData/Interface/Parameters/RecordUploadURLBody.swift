//
//  RecordUploadURLBody.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 미션 기록 이미지 Presigned URL 생성  Request DTO
public struct MissionRecordUploadURLBody: Encodable {
  public let imageFileExtension: String
  public let recordId: Int
  
  public init(imageFileExtension: String, recordId: Int) {
    self.imageFileExtension = imageFileExtension
    self.recordId = recordId
  }
}
