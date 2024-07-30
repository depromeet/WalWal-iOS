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

/// 통신을 보낼 URL을 선택하는 enum 값 입니다.
/// S3 image 업로드 시에는 .presignedURL, 나머지에서는 .walWalBaseURL
///
/// 사용 예시
/// ``` swift
///     case .loadImagePresignedURL(_): // Presigned URL을 우리 서버에 요청
///       return .walWalBaseURL
///     case let .uploadImage(url): // S3 Bucket에 이미지 업로드
///       return .presignedURL(url)
///  ```
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

/// HTTP Header를 상수처럼 사용하기 위해 정의한 Type
enum HTTPHeaderFieldKey : String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
}

enum HTTPHeaderFieldValue: String {
    case json = "Application/json"
    case accessToken
}

/// HTTP Header 설정 enum입니다.
/// 추후 헤더에 다른 값을 넣게 된다면 case를 추가
///
/// 사용 예시
/// ``` swift
///     case .loadImagePresignedURL(_): // Presigned URL을 우리 서버에 요청
///       return .authorization("토큰값")
///     case let .uploadImage(url): // S3 Bucket에 이미지 업로드
///       return .plain
///  ```
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
