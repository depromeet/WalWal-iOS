//
//  NetworkService.swift
//  Network
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

// MARK: - NetworkError
/// NetworkError: 네트워크 요청 중 발생할 수 있는 에러 타입을 정의
enum NetworkError: Error {
    case invalidRequest
    case httpError(Int)
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}


// MARK: - NetworkService
/// NetworkService: 네트워크 서비스 프로토콜 정의
/// 네트워크 요청을 수행하는 메서드를 정의합니다.
protocol NetworkServiceProtocol {
    /// request(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트를 받아 Single<T> 타입의 Observable을 반환합니다.
    /// 공통되는 엔티티를 사용하기 위해 BaseResponse를 사용합니다.
    func request<T: Decodable>(endpoint: APIEndpoint) -> Single<T>
    /// upload(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트와 업로드할 데이터를 받아 Single<T> 타입의 Observable을 반환합니다.
    func upload<T: Decodable>(endpoint: APIEndpoint, data: [UploadData]) -> Single<T>
}
