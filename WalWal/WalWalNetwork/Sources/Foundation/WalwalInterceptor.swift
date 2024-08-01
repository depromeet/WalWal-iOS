//
//  WalwalInterceptor.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import Utility

import Alamofire
import RxSwift

final public class WalwalInterceptor: RequestInterceptor {
  
  private var retryLimit = 2
  private let reissueRepository = ReissueRepository(networkService: NetworkService())
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
        let reissueUsecase = ReissueUsecase(reissueRepository: reissueRepository)
        // TODO: refreshToken이 없는 경우 error 방출
        if let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
          reissueUsecase.excute(refreshToken: refreshToken)
            .subscribe(
              onSuccess: { token in
                /// 토큰 변경 로직
                /// ex)
                /// UserDefaults.standard.setValue(token.refreshToken, forKey: "refreshToken")
                ///
                /// 요청 재시도
                completion(.retry)
              },
              onFailure: { err in
                print("🚨 토큰 갱신 실패: \(err)")
                completion(.doNotRetryWithError(error))
              })
            .disposed(by: disposeBag)
        } else  {
          completion(.doNotRetryWithError(error))
          /// 로그인 뷰로 이동
        }
      } else if statusCode == 404 {
        /// 유저를 찾을 수 없는 상태
      }
    }
  }
}
