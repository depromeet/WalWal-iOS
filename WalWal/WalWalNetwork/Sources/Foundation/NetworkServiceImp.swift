//
//  NetworkService.swift
//  WalWalNetwork
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import Alamofire
import RxAlamofire
import RxSwift

public final class NetworkService: NetworkServiceProtocol {
  /// request(:) 메서드는 APIEndpoint 프로토콜을 준수하는 엔드포인트를 받아 네트워크 요청을 수행합니다.
  /// - Parameter endpoint: APIEndpoint 프로토콜을 준수하는 엔드포인트
  /// - Returns: Single<EP.Response> 타입의 Observable
  /// --> Response는 associatedtype으로 정의하여, APIEndpoint를 준수하는 다양한 타입의 data(내부 프로퍼티)를 다룰 수 있게 함.
  
  public init() {
    
  }
  
  public func request<E: APIEndpoint>(endpoint: E, isNeedInterceptor: Bool = true) -> Single<E.ResponseType?> where E: APIEndpoint {
    requestLogging(endpoint)
    return RxAlamofire.requestJSON(endpoint, interceptor: isNeedInterceptor ? WalwalInterceptor() : nil)
      .map { response, anyData -> (HTTPURLResponse, Data) in
        let convertedData = try JSONSerialization.data(withJSONObject: anyData)
        return (response, convertedData)
      }
      .catch({ error in
        print(error.localizedDescription)
        guard let afError = error.asAFError, let responseCode = afError.responseCode else {
          let walwalError = WalWalNetworkError.unknown(error)
          self.responseError(endpoint, statusCode: -1, result: walwalError)
          return .error(walwalError)
        }
        
        let walwalError = WalWalNetworkError.networkError(message: nil)
        self.responseError(endpoint, statusCode: responseCode, result: walwalError)
        return .error(walwalError)
      })
      .withUnretained(self)
      .flatMap { owner, result -> Single<E.ResponseType?> in
        let (response, data) = result
        let convertedResult = owner.convertToResponse(response, data, E.ResponseType.self, endpoint)
        switch convertedResult {
        case .success(let responseData):
          return .just(responseData)
        case .failure(let error):
          return .error(error)
        }
      }
      .asSingle()
  }
  
  // MARK: - Image Upload
  
  /// 이미지를 Presigned URL로 업로드 하는 함수입니다.
  ///
  /// 사용 예시
  /// ``` swift
  /// let imageData = image.jpegData(compressionQuality: 0.8)! // UIImage -> jpegData
  /// networkService.upload(endpoint, imageData: imageData)
  /// ```
  public func upload<E: APIEndpoint> (endpoint: E, imageData: Data) -> Single<Bool> where E: APIEndpoint{
    requestLogging(endpoint)
    let headers: HTTPHeaders = HTTPHeaders(endpoint.headers)
    return Single.create { single -> Disposable in
      AF.upload(imageData,
                to: endpoint.baseURL,
                method: .put,
                headers: headers)
        .validate(statusCode: 200...299)
        .responseData(emptyResponseCodes: [200]) { response in
          switch response.result {
          case .success(_):
            single(.success(true))
          case .failure(let fail):
            let error = WalWalNetworkError.networkError(message: nil)
            single(.failure(error))
          }
        }
      return Disposables.create()
    }
  }
}

// MARK: - Private Method

extension NetworkService {
  private func convertToResponse<T: Decodable>(
    _ response: HTTPURLResponse,
    _ data: Data,
    _ model: T.Type,
    _ endpoint: any APIEndpoint
  ) -> Result<T?, Error> {
    let statusCode = response.statusCode
    if !(200...299).contains(statusCode) {
      var error = WalWalNetworkError.serverError(message: nil)
      do {
        let errorResponse = try JSONDecoder().decode(BaseResponse<ErrorResponse>.self, from: data)
        dump(errorResponse)
        switch statusCode {
        case 400...499:
          error = WalWalNetworkError.networkError(message: errorResponse.data?.message)
        case 500...599:
          error = WalWalNetworkError.serverError(message: errorResponse.data?.message)
        default:
          error = WalWalNetworkError.networkError(message: nil)
        }
      } catch { }
     
      responseError(endpoint, statusCode: statusCode, result: error)
      return .failure(error)
    }
    do {
      let responseModel = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
      if responseModel.success {
        responseSuccess(endpoint, result: responseModel)
        return .success(responseModel.data)
      } else {
        let error = WalWalNetworkError.networkError(message: nil)
        responseError(endpoint, statusCode: statusCode, result: error)
        return .failure(error)
      }
    } catch {
      let decodingError = WalWalNetworkError.decodingError(error)
      responseError(endpoint, statusCode: statusCode, result: decodingError)
      return .failure(decodingError)
    }
  }
  
  private func requestLogging(_ endpoint: any APIEndpoint) {
    print("""
              ================== 📤 Request ===================>
              📝 URL: \(endpoint.baseURL.absoluteString + endpoint.path)
              📝 HTTP Method: \(endpoint.method.rawValue)
              📝 Header: \(endpoint.headers)
              📝 Parameters: \(parametersToDictionary(endpoint.parameters) ?? [:])
              ================================
          """)
  }
  
  private func responseSuccess<T: Decodable>(_ endpoint: any APIEndpoint, result response: BaseResponse<T>) {
    print("""
              ======================== 📥 Response <========================
              ========================= ✅ Success =========================
              ✌🏻 URL: \(endpoint.baseURL.absoluteString + endpoint.path)
              ✌🏻 Header: \(endpoint.headers)
              ✌🏻 Success_Data: \(String(describing: response.data))
              ==============================================================
          """)
  }
  
  private func responseError(_ endpoint: any APIEndpoint, statusCode: Int , result error: WalWalNetworkError) {
    print("""
              ======================== 📥 Response <========================
              ========================= ❌ Error.. =========================
              ❗️ URL: \(endpoint.baseURL.absoluteString + endpoint.path)
              ❗️ Header: \(endpoint.headers)
              ❗️ StatusCode: \(statusCode)
              ❗️ Error_Data: \(error.errorDescription ?? "Unknown Error Occured")
              ==============================================================
          """)
  }
  
  private func parametersToDictionary(_ parameters: RequestParams) -> [String: Any]? {
    switch parameters {
    case .requestPlain:
      return nil
    case .requestQuery(let parameter),
        .requestWithbody(let parameter),
        .requestQueryWithBody(_, let parameter):
      return parameter?.toDictionary()
    case .upload:
      return nil
    }
  }
}

extension Data {
  var toPrettyPrintedString: String? {
    do {
      let object = try JSONSerialization.jsonObject(with: self, options: [])
      let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
      let prettyPrintedString = String(data: data, encoding: .utf8)
      return prettyPrintedString
    } catch {
      return nil
    }
  }
}
