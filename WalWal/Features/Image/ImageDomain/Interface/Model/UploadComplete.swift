//
//  UploadComplete.swift
//  ImageDomain
//
//  Created by Jiyeon on 8/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import ImageData

public struct UploadComplete {
  public let imageURL: String
  
  public init(dto: UploadCompleteDTO) {
    self.imageURL = dto.imageUrl
  }
}
