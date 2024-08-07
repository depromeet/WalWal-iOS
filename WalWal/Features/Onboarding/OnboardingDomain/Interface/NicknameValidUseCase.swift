//
//  NicknameValidUseCase.swift
//  OnboardingDomain
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol NicknameValidUseCase {
  func excute(nickname: String) -> Single<Void>
}
