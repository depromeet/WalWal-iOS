//
//  SampleAuthRepository.swift
//  SampleDataImp
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift

public protocol SampleAuthRepository {
  /// - 기능에 따라서 필요한 함수를 추가해주세요.
  func signUp(nickname: String, profile: Data) -> Single<SampleSignUpDTO>
  func signIn(id: String, password: String) -> Single<SampleSignInDTO>
}

