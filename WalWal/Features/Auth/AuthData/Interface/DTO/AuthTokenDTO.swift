//
//  AuthTokenDTO.swift
//  AuthData
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain

public struct AuthTokenDTO: Decodable {
  public let token: String
  
  /// Domain layer의 모델 타입 변환 메서드
  public func toModel() -> AuthToken {
    return .init(token: token)
  }
}
