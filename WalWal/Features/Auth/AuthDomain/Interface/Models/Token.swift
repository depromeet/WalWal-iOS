//
//  Token.swift
//  AuthDomain
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthData

public struct Token {
  public var token: String
  
  public init(dto: SignUpDTO) {
    self.token = dto.token
  }
  
  public init(dto: SignInDTO) {
    self.token = dto.token
  }
}