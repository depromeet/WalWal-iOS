//
//  RegisterUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol RegisterUseCase {
  func execute(nickname: String, petType: String, defaultProfile: String?) -> Single<AuthToken>
}
