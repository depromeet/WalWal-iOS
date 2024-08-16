//
//  ImageDependencyFactoryImplement.swift
//
//  Image
//
//  Created by 이지희
//

import Foundation
import ImageDependencyFactory

import WalWalNetwork

import ImageData
import ImageDataImp
import ImageDomain
import ImageDomainImp

public class ImageDependencyFactoryImp: ImageDependencyFactory {

  public init() {  }
  
  public func injectImageRepository() -> any ImageRepository {
    let networkService = NetworkService()
    return ImageRepositoryImp(networkService: networkService)
  }
  
  public func injectUploadMemberUseCase() -> any UploadMemberUseCase {
    return UploadMemberUseCaseImp(imageRepository: injectImageRepository())
  }
  
  public func injectUploadRecordUseCase() -> any UploadRecordUseCase {
    return UploadRecordUseCaseImp(imageRepository: injectImageRepository())
  }
  
  
}
