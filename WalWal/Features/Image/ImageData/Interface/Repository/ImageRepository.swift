//
//  ImageRepository.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol ImageRepository {
  func requestMemberUploadURL(type: String, image: Data) -> Single<Bool>
  func uploadMemberImage(nickname: String, type: String, image: Data) -> Single<UploadCompleteDTO>
  func requestMissionUploadURL(type: String, recordId: Int, image: Data) -> Single<Bool>
  func uploadMissionImage(recordId: Int, type: String, image: Data) -> Single<Void>
}

