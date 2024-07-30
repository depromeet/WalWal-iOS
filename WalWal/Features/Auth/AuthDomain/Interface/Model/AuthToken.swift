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
  public let accessToken: String
  public let refreshToken: String
  public let isTemporaryToken: Bool
  
  public init(dto: AuthTokenDTO) {
    self.accessToken = dto.accessToken
    self.refreshToken = dto.refreshToken
    self.isTemporaryToken = dto.isTemporaryToken
  }
}
