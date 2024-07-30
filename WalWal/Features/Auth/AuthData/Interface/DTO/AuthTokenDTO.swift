//
//  AuthTokenDTO.swift
//  AuthData
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct AuthTokenDTO: Decodable {
  public let accessToken: String
  public let refreshToken: String
  public let isTemporaryToken: Bool
}
