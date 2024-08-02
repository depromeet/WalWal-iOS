//
//  NetworkError.swift
//  WalWalNetwork
//
//  Created by 이지희 on 7/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - NetworkError

/// NetworkError: 네트워크 요청 중 발생할 수 있는 에러 타입을 정의
public enum WalWalNetworkError: Error {
  case invalidRequest
  case networkError(Int)
  case serverError(statusCode: Int)
  case decodingError(Error)
  case tokenReissueFailed
  case unknown(Error)
}

extension WalWalNetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidRequest:
      return "해당 요청이 유효하지 않습니다."
    case .decodingError:
      return "데이터 타입을 decode 하는데에 실패하였습니다."
    case .serverError(let code):
      return "서버 에러가 발생했습니다. \(code)"
    case .networkError(let code):
      return "네트워크 오류입니다 \(code)"
    case .tokenReissueFailed:
      return "토큰 재발급에 실패했습니다. 다시 로그인해주세요."
    case .unknown(let error):
      return "알 수 없는 에러 입니다. : \(error)"
    }
  }
}