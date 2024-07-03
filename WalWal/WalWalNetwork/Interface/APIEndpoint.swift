import Foundation

import Alamofire
import RxAlamofire

/// HTTPHeader 타입 입니다.
public typealias WalWalHTTPHeader = [String: String]

/// APIEndpoint 프로토콜
/// API 엔드포인트를 정의하는 용도로 사용됩니다.
public protocol APIEndpoint: URLRequestConvertible {
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
