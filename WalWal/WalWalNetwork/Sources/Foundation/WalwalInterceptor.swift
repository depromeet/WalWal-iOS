//
//  WalwalInterceptor.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import Foundation
import Utility
import LocalStorage

import Alamofire
import RxSwift

final public class WalwalInterceptor: RequestInterceptor {
  
  private var retryLimit = 2
  private let disposeBag = DisposeBag()
  
  init() { }
  
  public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    completion(.success(urlRequest))
  }
  
  public func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
    print("interceptor retry💥")
    guard
      let statusCode = request.response?.statusCode,
      request.retryCount < retryLimit
    else {
      print("🚨 재시도 횟수가 너무 많습니다")
      return completion(.doNotRetry)
    }
    
    if request.retryCount < retryLimit {
      if statusCode == 401 {
        /// refresh 토큰이 존재하는 경우
        let refreshToken = UserDefaults.string(forUserDefaultsKey: .refreshToken)
        if refreshToken != "" {
          let endpoint = ReissueEndpoint<Token>.reissue(body: RefreshToken(refreshToken: refreshToken))
          NetworkService().request(endpoint: endpoint)
            .subscribe(onSuccess: { token in
              guard let token = token else {
                completion(.doNotRetryWithError(WalWalNetworkError.tokenReissueFailed))
                return
              }
              /// 토큰 업데이트
              UserDefaults.setValue(value: token.refreshToken, forUserDefaultKey: .refreshToken)
              KeychainWrapper.shared.setAccessToken(token.accessToken) ? completion(.retry) : completion(.doNotRetry)
            }, onFailure: { err in
              print("🚨 토큰 갱신 실패: \(err)")
              completion(.doNotRetryWithError(WalWalNetworkError.tokenReissueFailed))
            })
            .disposed(by: disposeBag)
          /// refresh 토큰이 존재하지 않은 경우
        } else  {
          completion(.doNotRetryWithError(WalWalNetworkError.tokenReissueFailed))
        }
      }
    } else if statusCode == 404 {
      /// 유저를 찾을 수 없는 상태
      completion(.doNotRetry)
    }
  }
}
