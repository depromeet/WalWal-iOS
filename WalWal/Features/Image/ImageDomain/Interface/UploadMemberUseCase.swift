//
//  UploadMemberUseCase.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol UploadMemberUseCase {
  func execute(nickname: String, type: String, image: Data) -> Single<UploadComplete>
}

