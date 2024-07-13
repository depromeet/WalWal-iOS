import Foundation

import Alamofire
import RxAlamofire

/// HTTPHeader 타입 입니다.
public typealias WalWalHTTPHeader = [String: String]

/// APIEndpoint 프로토콜
/// API 엔드포인트를 정의하는 용도로 사용됩니다.
public protocol APIEndpoint: URLRequestConvertible {
  associatedtype ResponseType: Decodable
  
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: RequestParams { get }
  var headers: WalWalHTTPHeader { get }
}

public enum RequestParams {
  case requestPlain
  case requestQuery(_ parameter: Encodable?)
  case requestWithbody(_ parameter: Encodable?)
  case requestQueryWithBody(_ queryParameter: Encodable?, _ bodyParameter: Encodable?)
  case uploadMultipart([MultipartFormData])
}

public extension APIEndpoint {
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
    case .uploadMultipart(_):
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

extension Encodable {
  public func toDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let dictionaryData = jsonData as? [String: Any] else { return [:] }
    return dictionaryData
  }
}
