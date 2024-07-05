//
//  APIEndpointImpl.swift
//  WalWalNetworkImp
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
extension APIEndpoint {
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
            urlRequest.url = try configureQueryParams(url: url.appendingPathComponent(path), query: query)
        case .requestWithbody(let body):
            urlRequest.httpBody = try configureBodyParams(body: body)
        case .requestQueryWithBody(let query, let body):
            urlRequest.url = try configureQueryParams(url: url.appendingPathComponent(path), query: query)
            urlRequest.httpBody = try configureBodyParams(body: body)
        case .uploadMultipart(_):
            break
        }
        return urlRequest
    }
    
    private func configureQueryParams(url: URL, query: Encodable?) throws -> URL {
        let params = query?.toDictionary() ?? [:]
        let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParams
        guard let configuredURL = components?.url else {
            throw URLError(.badURL)
        }
        return configuredURL
    }
    
    private func configureBodyParams(body: Encodable?) throws -> Data {
        let params = body?.toDictionary() ?? [:]
        return try JSONSerialization.data(withJSONObject: params, options: [])
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
