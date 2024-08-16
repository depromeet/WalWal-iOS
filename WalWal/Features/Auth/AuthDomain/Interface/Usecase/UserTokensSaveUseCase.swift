//
//  UserTokensSaveUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public protocol UserTokensSaveUseCase {
  func execute(tokens: AuthToken)
}
