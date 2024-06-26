import Foundation

import RxAlamofire

/// APIEndpoint 프로토콜
/// API 엔드포인트를 정의하는 용도로 사용됩니다.
protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
