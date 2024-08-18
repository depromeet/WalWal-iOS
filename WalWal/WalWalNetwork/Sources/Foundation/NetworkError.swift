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
  case networkError(message: String?)
  case serverError(message: String?)
  case decodingError(Error)
  case tokenReissueFailed
  case retryExceeded(Error)
  case unknown(Error)
}

extension WalWalNetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidRequest:
      return "해당 요청이 유효하지 않습니다."
    case .decodingError(let error):
      return "데이터 타입을 decode 하는데에 실패하였습니다.\(error)"
    case .serverError(let message):
      let message = message ?? "서버에 문제가 발생하였습니다."
      return "\(message)"
    case .networkError(let message):
      let message = message ?? "요청에 문제가 발생하였습니다."
      return "\(message)"
    case .tokenReissueFailed:
      return "토큰 재발급에 실패했습니다. 다시 로그인해주세요."
    case .retryExceeded(let error):
      return "retry 횟수 초과입니다. \(error)"
    case .unknown(let error):
      return "알 수 없는 에러 입니다. : \(error)"
    }
  }
}
