//
//  NetworkService.swift
//  WalWalNetwork
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

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
  public func request<T: Decodable>(endpoint: APIEndpoint) -> Single<T> {
    /// url 생성
    let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
    /// 헤더 타입 변경
    let headers = HTTPHeaders(endpoint.headers)
    requestLogging(endpoint, headers)
    
    /// 추후에 interceptor 추가 가능
    return RxAlamofire.requestJSON(endpoint.method,
                                   url,
                                   parameters: parametersToDictionary(endpoint.parameters),
                                   headers: headers)
    .flatMap { response, data -> Single<T> in
      if !(200...299).contains(response.statusCode) {
        throw WalWalNetworkError.serverError(statusCode: response.statusCode)
      }
      self.responseLogging((data as? Data)?.toPrettyPrintedString ?? "")
      return self.decode(T.self, from: try JSONSerialization.data(withJSONObject: data))
    }
    .asSingle()
    .catch { error in
      if let afError = error as? AFError,
         let statusCode = afError.responseCode {
        return .error(WalWalNetworkError.serverError(statusCode: statusCode))
      } else {
        return .error(WalWalNetworkError.unknown(error))
      }
    }
  }
  
  /// upload(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트와 업로드할 데이터를 받아 네트워크 요청을 수행합니다.
  /// - Parameter endpoint: APIEndpoint 프로토콜을 준수하는 엔드포인트
  /// - Parameter data: 업로드할 데이터 배열
  /// - Returns: Single<T> 타입의 Observable
  public func upload<T: Decodable>(endpoint: APIEndpoint, data: [UploadData]) -> Single<T> {
    /// url 생성
    let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
    /// 헤더 타입 변경
    let headers = HTTPHeaders(endpoint.headers)
    
    requestLogging(endpoint, headers)
    
    return RxAlamofire.upload(multipartFormData: { multipartFormData in
      for item in data {
        switch item {
        case .file(let fileData, let name, let fileName, let mimeType):
          multipartFormData.append(fileData, withName: name, fileName: fileName, mimeType: mimeType)
        case .parameter(let name, let value):
          multipartFormData.append(Data(value.utf8), withName: name)
        }
      }
    }, to: url, method: endpoint.method, headers: headers)
    .flatMap { request in
      request.rx.responseData()
    }
    .flatMap { response, data -> Single<T> in
      guard 200..<300 ~= response.statusCode else {
        throw WalWalNetworkError.networkError(response.statusCode)
      }
      self.responseLogging(data.toPrettyPrintedString ?? "")
      return self.decode(T.self, from: data)
    }
    .asSingle()
  }
  
  private func requestLogging(_ endpoint: APIEndpoint, _ headers: HTTPHeaders?) {
    print("======== 📤 Request ==========>")
    print("HTTP Method: \(endpoint.method.rawValue)")
    print("URL: \(endpoint.baseURL.absoluteString + endpoint.path)")
    print("Header: \(headers ?? [:])")
    print("Parameters: \(parametersToDictionary(endpoint.parameters) ?? [:])")
    print("================================")
  }
  
  private func responseLogging(_ dataString: String) {
    print("======== 📥 Response <==========")
    print(dataString)
    print("================================")
  }
  
  private func parametersToDictionary(_ parameters: RequestParams) -> [String: Any]? {
    switch parameters {
    case .requestPlain:
      return nil
    case .requestQuery(let parameter),
        .requestWithbody(let parameter),
        .requestQueryWithBody(_, let parameter):
      return parameter?.toDictionary()
    case .uploadMultipart:
      return nil
    }
  }
  
  private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Single<T> {
    do {
      let result = try JSONDecoder().decode(T.self, from: data)
      return .just(result)
    }
    catch {
      return .error(WalWalNetworkError.decodingError(error))
    }
  }
}

extension Data {
  var toPrettyPrintedString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    return prettyPrintedString as String?
  }
}

// MARK: NetworkReachability

enum NetworkStatusType {
  case disconnect
  case connect
  case unknown
}

/// 네트워크 연결 여부를 확인하는 싱글톤 클래스 입니다
public final class NetworkReachability {
  static let shared = NetworkReachability()
  
  /// Almofire에서 제공하는 네트워크 상태 매니저
  private let reachabilityManager = NetworkReachabilityManager()
  private let disposeBag = DisposeBag()
  fileprivate let statusPublish = PublishSubject<NetworkStatusType>()
  var statusObservable: Observable<NetworkStatusType>{
    statusPublish
      .debug()
  }
  
  private init() {
    observeReachability()
  }
  
  
  /// 네트워크 상태 변화를 나타내는 Observable
  /// 사용 예시
  /// ``` swift
  ///  NetworkReachability.shared.statusObservable
  ///   .subscribe (onNext: {
  ///      print($0)
  ///   })
  ///   .dispose(by: disposeBag)
  /// ```
  func observeReachability() {
    let reachability = NetworkReachabilityManager()
    reachability?.startListening(onUpdatePerforming: { [weak statusPublish] status in
      switch status {
      case .notReachable:
        statusPublish?.onNext(.disconnect)
      case .reachable(.cellular), .reachable(.ethernetOrWiFi):
        statusPublish?.onNext(.connect)
      case .unknown:
        statusPublish?.onNext(.unknown)
      }
    })
  }
  
  /// 네트워크가 연결되었는지 확인하는 메서드
  ///
  /// 사용 예시
  /// ``` swift
  /// view.backgroundColor = NetworkReachability.shared.isReachable() ? .blue : .gray
  /// ```
  func isReachable() -> Bool {
    return reachabilityManager?.isReachable ?? false
  }
  
  /// 네트워크 상태 모니터링 중지
  func stopMonitoring() {
    reachabilityManager?.stopListening()
  }
}
