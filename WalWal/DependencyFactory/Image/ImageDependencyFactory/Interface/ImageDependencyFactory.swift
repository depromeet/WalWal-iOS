//
//  ImageDependencyFactoryInterface.swift
//
//  Image
//
//  Created by 이지희
//

import UIKit

import ImageData
import ImageDomain

public protocol ImageDependencyFactory {
  func injectImageRepository() -> ImageRepository
  func injectUploadMemberUseCase() -> UploadMemberUseCase
  func injectUploadRecordUseCase() -> UploadRecordUseCase
}
