//
//  UploadImageUseCase.swift
//  OnboardingDomain
//
//  Created by Jiyeon on 8/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol UploadImageUseCase {
  func excute(nickname: String, type: String, image: Data) -> Single<Void>
}
