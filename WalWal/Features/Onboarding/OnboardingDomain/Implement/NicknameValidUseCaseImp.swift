//
//  NicknameValidUseCaseImp.swift
//  OnboardingDomain
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import OnboardingData
import OnboardingDomain

import RxSwift

public final class NicknameValidUseCaseImp: NicknameValidUseCase {
  
  let onboardingRepository: OnboardingRepository
  
  public init(repository: OnboardingRepository) {
    self.onboardingRepository = repository
  }
  
  public func execute(nickname: String) -> Single<Void> {
    return onboardingRepository.checkValidNickname(nickname: nickname)
  }
  
}
