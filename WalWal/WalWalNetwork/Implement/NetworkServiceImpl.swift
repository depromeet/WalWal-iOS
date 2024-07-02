//
//  NetworkService.swift
//  Network
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

final class NetworkService: NetworkServiceProtocol {
    /// request(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트를 받아 네트워크 요청을 수행합니다.
    /// - Parameter endpoint: APIEndpoint 프로토콜을 준수하는 엔드포인트
    /// - Returns: Single<T> 타입의 Observable
    /// 사용예시
    /// ``` swift
    /// let networkService = NetworkService()
    /// networkService.request(endpoint: MyAPIEndpoint()).subscribe(onSuccess: { (result: MyDataType) in
    ///     print(result)
    /// }, onError: { error in
    ///     print(error)
    /// })
    /// ```
    func request<T: Decodable>(endpoint: APIEndpoint) -> Single<T> {
        /// url 생성
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        /// 헤더 타입 변경
        let headers = HTTPHeaders(endpoint.headers)
        requestLogging(endpoint, headers)
        
        /// 추후에 interceptor 추가 가능
        return RxAlamofire.requestJSON(endpoint.method,
                                       url,
                                       parameters: parametersToDictionary(endpoint.parameters),
                                       headers: HTTPHeaders(endpoint.headers) )
        .flatMap { response, data -> Single<T> in
            do {
                throw NetworkError.serverError(statusCode: response.statusCode)
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                responseLogging(data.toPrettyPrintedString ?? "")
                return .just(decodedObject)
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
        .asSingle()
        .catchError { error in
            if let afError = error as? AFError,
               let statusCode = afError.responseCode {
                return .error(NetworkError.serverError(statusCode: statusCode))
            } else {
                return .error(NetworkError.unknown(error))
            }
        }
    }
    
    private func requestLogging(_ endpoint: APIEndPoint) {
        print("======== 📤 Request ==========>")
        print("HTTP Method: \(endpoint.method.rawValue)")
        print("URL: \(endpoint.baseURL.absoluteString + endpoint.path)")
        print("Header: \(headers ?? .default)")
        print("Parameters: \(endpoint.parameters ?? .init())")
        print("================================")
    }
    
    private func responseLogging(_ dataString: String) {
        print("======== 📥 Response <==========")
        print(dataString)
        print("================================")
    }
}

// MARK: NetworkReachability
/// 네트워크 연결 여부를 확인하는 싱글톤 클래스 입니다
final class NetworkReachability {
    static let shared = NetworkReachability()
    
    /// Almofire에서 제공하는 네트워크 상태 매니저
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {}
    
    /// 네트워크가 연결되었는지 확인하는 메서드
    ///
    /// 사용 예시
    /// ``` swift
    /// view.backgroundColor = NetworkReachability.shared.isReachable() ? .blue : .gray
    /// ```
    func isReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    /// 네트워크 상태 모니터링 시작
    ///
    /// 사용 예시
    /// ```
    /// NetworkReachability.shared.startMonitoring()
    /// ```
    func startMonitoring() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                print("네트워크 연결을 할 수 없습니다.")
            case .reachable(.cellular):
                print("셀룰러 데이터 연결")
            case .reachable(.ethernetOrWiFi):
                print("와이파이 연결")
            case .unknown:
                print("알 수 없는 네트워크 연결")
            }
        })
    }
    
    /// 네트워크 상태 모니터링 중지
    func stopMonitoring() {
        reachabilityManager?.stopListening()
    }
}
