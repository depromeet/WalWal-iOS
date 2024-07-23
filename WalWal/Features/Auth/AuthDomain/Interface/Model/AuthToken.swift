//
//  AuthToken.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData

/// 로그인 완료 후 서버에서 받은 토큰 값이 저장됩니다.
public struct AuthToken {
  public let token: String
  
  public init(dto: AuthTokenDTO) {
    self.token = dto.token
  }
}
