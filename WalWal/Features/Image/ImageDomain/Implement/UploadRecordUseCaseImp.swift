//
//  UploadRecordUseCaseImp.swift
//  ImageDomain
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ImageData
import ImageDomain

import RxSwift

public class UploadRecordUseCaseImp: UploadRecordUseCase {
  
  let imageRepository: ImageRepository
  
  public init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  public func execute(recordId: Int, type: String, image: Data) -> Single<Void> {
    imageRepository.uploadMissionImage(recordId: recordId, type: type, image: image)
  }
}

