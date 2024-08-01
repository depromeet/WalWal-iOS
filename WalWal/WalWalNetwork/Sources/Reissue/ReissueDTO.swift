//
//  ReissueDTO.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

/// 토큰 재발급 요청 Body
struct ReissueRequestDTO: Encodable {
  let refreshToken: String
}

/// 토큰 재발급 response
struct ReissueResponseDTO: Decodable {
  let accessToken: String
  let refreshToken: String
  let isTemporaryToken: Bool
}
