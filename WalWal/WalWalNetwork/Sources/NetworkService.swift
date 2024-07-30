//
//  NetworkService.swift
//  WalWalNetwork
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

// MARK: - NetworkService

/// NetworkService: 네트워크 서비스 프로토콜 정의
/// 네트워크 요청을 수행하는 메서드를 정의합니다.
public protocol NetworkServiceProtocol {
  /// request(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트를 받아 Single<T> 타입의 Observable을 반환합니다.
  /// 공통되는 엔티티를 사용하기 위해 BaseResponse를 사용합니다.
  func request<E: APIEndpoint>(endpoint: E) -> Single<E.ResponseType?> where E: APIEndpoint
}
