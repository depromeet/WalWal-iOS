//
//  OnboardingRepositoryImp.swift
//  OnboardingData
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import OnboardingData

import RxSwift

public final class OnboardingRepositoryImp: OnboardingRepository {
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func checkValidNickname(nickname: String) -> Single<Void> {
    let body = NicknameCheckBody(nickname: nickname)
    let endpoint = OnboardingEndPoint<EmptyResponse>.checkNickname(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: false)
      .map { _ in return () }
  }
  
  public func uploadImage(nickname: String, type: String, image: Data) -> Single<Void> {
    let completeBody = UploadCompleteBody(imageFileExtension: type, nickname: nickname)
    let endpoint = OnboardingEndPoint<EmptyResponse>.uploadComplete(body: completeBody)
    
    return requestUploadImage(type: type, image: image)
      .flatMap { [weak self] result -> Single<Void> in
        guard let self = self else { return .never() }
        return self.networkService.request(endpoint: endpoint, isNeedInterceptor: false)
          .map { _ in Void() }
      }
  }
  
  private func requestUploadImage(type: String, image: Data) -> Single<Bool> {
    let body = PresignedURLBody(imageFileExtension: type)
    let endpoint = OnboardingEndPoint<PresignedURLDTO>.requestPresignedUrl(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: false)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
      .flatMap { [weak self] result in
        guard let self = self else { return .never() }
        let endpoint = OnboardingEndPoint<EmptyResponse>.uploadImage(url: result.presignedUrl)
        return self.networkService.upload(endpoint: endpoint, imageData: image)
      }
  }
}
