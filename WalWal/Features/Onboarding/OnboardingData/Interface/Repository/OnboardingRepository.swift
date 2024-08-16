//
//  OnboardingRepository.swift
//  OnboardingData
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol OnboardingRepository {
  func checkValidNickname(nickname: String) -> Single<Void>
  func uploadImage(nickname: String, type: String, image: Data) -> Single<Void>
}
