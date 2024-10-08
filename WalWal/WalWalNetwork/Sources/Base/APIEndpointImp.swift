//
//  APIEndpointImp.swift
//  WalWalNetwork
//
//  Created by 이지희 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import Alamofire

public extension APIEndpoint {
  var baseURL: URL {
    switch baseURLType {
    case .walWalBaseURL:
      let BASE_URL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
      return URL(string: "https://dev-api.walwal.life")!
    case .presignedURL(let string):
      return URL(string: string)!
    }
  }
  
  var headers: WalWalHTTPHeader {
    switch headerType {
    case .plain:
      return [
        HTTPHeaderFieldKey.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue
      ]
    case .authorization(let token):
      return [
        HTTPHeaderFieldKey.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue,
        HTTPHeaderFieldKey.authentication.rawValue: "Bearer \(token)"
      ]
    case .uploadJPEG:
      return [
        HTTPHeaderFieldKey.contentType.rawValue: HTTPHeaderFieldValue.jpeg.rawValue
      ]
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try configureURL(baseURL)
    var urlRequest = try URLRequest(url: url, method: method)
    urlRequest = configureHeader(urlRequest)
    
    switch parameters {
    case .requestPlain:
      break
    case .requestQuery(let query):
      urlRequest.url = try configureQueryParams(url: url, query: query)
    case .requestWithbody(let body):
      urlRequest.httpBody = try configureBodyParams(body: body)
    case .requestQueryWithBody(let query, let body):
      urlRequest.url = try configureQueryParams(url: url, query: query)
      urlRequest.httpBody = try configureBodyParams(body: body)
    case .upload:
      break
    }
    return urlRequest
  }
  
  private func configureURL(_ url: URL) throws -> URL {
    let baseURL = try baseURL.asURL()
    let url = baseURL.appendingPathComponent(path)
    return url
  }
  
  private func configureHeader(_ urlRequest: URLRequest) -> URLRequest {
    var urlRequest = urlRequest
    for (headerField, headerValue) in headers {
      urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
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
