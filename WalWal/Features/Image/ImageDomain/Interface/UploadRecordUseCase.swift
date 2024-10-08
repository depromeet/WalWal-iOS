//
//  UploadRecordUseCase.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol UploadRecordUseCase {
  func execute(recordId: Int, type: String, image: Data) -> Single<Void>
}
