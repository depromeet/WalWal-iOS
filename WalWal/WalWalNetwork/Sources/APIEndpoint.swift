import Foundation

import Alamofire

/// HTTPHeader 타입 입니다.
public typealias WalWalHTTPHeader = [String: String]

/// APIEndpoint 프로토콜
/// API 엔드포인트를 정의하는 용도로 사용됩니다.
public protocol APIEndpoint: URLRequestConvertible {
  associatedtype ResponseType: Decodable
  
  var baseURLType: URLType { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: RequestParams { get }
  var headerType: HTTPHeaderType { get }
}

public enum URLType {
  case walWalBaseURL
  case presignedURL(String)
}

public enum RequestParams {
  case requestPlain
  case requestQuery(_ parameter: Encodable?)
  case requestWithbody(_ parameter: Encodable?)
  case requestQueryWithBody(_ queryParameter: Encodable?, _ bodyParameter: Encodable?)
  case uploadImage
}

enum HTTPHeaderFieldKey : String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
}

enum HTTPHeaderFieldValue: String {
    case json = "Application/json"
    case accessToken
}

public enum HTTPHeaderType {
  case plain
  case authorization(String)
}

extension Encodable {
  public func toDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let dictionaryData = jsonData as? [String: Any] else { return [:] }
    return dictionaryData
  }
}
