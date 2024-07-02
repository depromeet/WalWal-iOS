//
//  APIEndpointImpl.swift
//  NetworkImp
//
//  Created by 이지희 on 6/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import WalWalNetwork
import Alamofire
import RxAlamofire

///URLRequestConvertible 프로토콜 구현부 :
/// URLRequest 객체를 생성하는 방법을 정의.

struct APIEndpointImpl: APIEndpoint, URLRequestConvertible {
    var baseURL: URL
    var path: String
    var method: HTTPMethod
    var parameters: RequestParams
    var headers: WalWalHTTPHeader
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        for (headerField, headerValue) in headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        
        switch parameters {
        case .requestPlain:
            break
        case .requestQuery(let query):
            let params = query?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .requestWithbody(let body):
            let params = body?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .requestQueryWithBody(let query, let body):
            let queryParams = query?.toDictionary().map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
            let bodyParams = body?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
        case .uploadMultipart(_):
            break
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
