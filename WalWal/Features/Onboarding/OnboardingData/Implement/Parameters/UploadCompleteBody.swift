//
//  UploadCompleteBody.swift
//  OnboardingData
//
//  Created by Jiyeon on 8/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct UploadCompleteBody: Encodable {
  let imageFileExtension: String
  let nickname: String
}
