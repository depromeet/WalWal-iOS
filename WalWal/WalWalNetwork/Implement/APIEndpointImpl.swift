//
//  APIEndpointImpl.swift
//  NetworkImp
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import Alamofire
import RxAlamofire

///URLRequestConvertible 프로토콜 구현부 :
/// URLRequest 객체를 생성하는 방법을 정의.
extension APIEndpoint: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        /// url  생성 후, path, method를 사용하여 urlRequest 생성
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        /// HTTPHeader
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        /// parameters 프로퍼티에 따라 query parameter 또는 request body 생성
        switch parameters {
        case .requestPlain:
            break
        case .requestQuery(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .requestWithbody(let request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .requestQueryWithBody(let query, let body):
                let params = queryRequest?.toDictionary()
                let queryParams = params?.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                var components = URLComponents(
                    string: url.appendingPathComponent(path).absoluteString)
                components?.queryItems = queryParams
                urlRequest.url = components?.url
                
                let bodyParams = bodyRequest?.toDictionary() ?? [:]
                
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams)
            
        }
        
        return urlRequest
    }
}


extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any] else { return [:] }
        return dictionaryData
    }
}
