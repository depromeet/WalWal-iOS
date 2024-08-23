//
//  ImageRepositoryImp.swift
//  ImageData
//
//  Created by 이지희 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import ImageData
import LocalStorage

import RxSwift

public final class ImageRepositoryImp: ImageRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func requestMemberUploadURL(type: String, image: Data) -> Single<Bool> {
    let body = MemberUploadUrlBody(imageFileExtension: type)
    let endpoint = ImageEndPoint<PresignedURLDTO>.membersUploadURL(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: false)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
      .flatMap { [weak self] result in
        guard let self = self else { return .never() }
        let endpoint = ImageEndPoint<EmptyResponse>.uploadMemberImage(url: result.presignedUrl)
        return self.networkService.upload(endpoint: endpoint, imageData: image)
      }
  }
  
  public func uploadMemberImage(nickname: String, type: String, image: Data) -> Single<UploadCompleteDTO> {
    let completeBody = MemberUploadBody(imageFileExtension: type, nickname: nickname)
    let endpoint = ImageEndPoint<UploadCompleteDTO>.membersUploadComplete(body: completeBody)
    let isTempraryUser = KeychainWrapper.shared.accessToken == nil
    
    return requestMemberUploadURL(type: type, image: image)
      .flatMap { [weak self] result -> Single<UploadCompleteDTO> in
        guard let self = self else { return .never() }
        return self.networkService.request(endpoint: endpoint, isNeedInterceptor: !isTempraryUser)
          .compactMap { $0 }
          .asObservable()
          .asSingle()
      }
  }
  
  public func requestMissionUploadURL(type: String, recordId: Int, image: Data) -> Single<Bool> {
    let body = MissionRecordUploadURLBody(imageFileExtension: type, recordId: recordId)
    let endpoint = ImageEndPoint<PresignedURLDTO>.recordUploadURL(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: false)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
      .flatMap { [weak self] result in
        guard let self = self else { return .never() }
        let endpoint = ImageEndPoint<EmptyResponse>.uploadRecordImage(url: result.presignedUrl)
        return self.networkService.upload(endpoint: endpoint, imageData: image)
      }
  }
  
  public func uploadMissionImage(recordId: Int, type: String, image: Data) -> Single<Void> {
    let completeBody = MissionRecordUploadBody(imageFileExtension: type, recordId: recordId)
    let endpoint = ImageEndPoint<EmptyResponse>.recordUploadComplete(body: completeBody)

    return requestMissionUploadURL(type: type, recordId: recordId, image: image)
      .flatMap { [weak self] result -> Single<Void> in
        guard let self = self else { return .never() }
        return self.networkService.request(endpoint: endpoint, isNeedInterceptor: false)
          .map { _ in Void() }
      }
  }
  
  
}
