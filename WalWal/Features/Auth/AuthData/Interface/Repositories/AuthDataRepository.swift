//
//  AuthDataRepository.swift
//  AuthData
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol AuthDataRepository {
  func appleLogin(token: String) -> Single<AuthTokenDTO>
}
