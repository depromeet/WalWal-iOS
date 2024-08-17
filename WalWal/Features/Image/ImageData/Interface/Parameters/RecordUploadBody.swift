//
//  RecordUploadBody.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import Foundation

/// 미션 기록 이미지 업로드 완료 Request Body
public struct MissionRecordUploadBody: Encodable {
  public let imageFileExtension: String
  public let recordId: Int
  
  public init(imageFileExtension: String, recordId: Int) {
    self.imageFileExtension = imageFileExtension
    self.recordId = recordId
  }
}
