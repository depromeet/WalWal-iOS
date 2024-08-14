//
//  AuthDataRepository.swift
//  AuthData
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol AuthRepository {
  func socialLogin(provider: String, token: String) -> Single<AuthTokenDTO>
  func register(nickname: String, petType: String, defaultProfile: String?) -> Single<AuthTokenDTO>
}
