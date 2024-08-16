//
//  UploadImageUseCaseImp.swift
//  OnboardingDomain
//
//  Created by Jiyeon on 8/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import OnboardingData
import OnboardingDomain

import RxSwift

public final class UploadImageUseCaseImp: UploadImageUseCase {
  let onboardingRepository: OnboardingRepository
  
  public init(onboardingRepository: OnboardingRepository) {
    self.onboardingRepository = onboardingRepository
  }
  
  public func execute(nickname: String, type: String, image: Data) -> Single<Void> {
    onboardingRepository.uploadImage(nickname: nickname, type: type, image: image)
  }
}
