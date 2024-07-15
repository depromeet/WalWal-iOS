//
//  AuthUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 7/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol AuthUseCase {
  /// 애플 로그인 요청 후 서버에서 토큰 값 반환하는 메서드 
  func appleLogin(authCode: String) -> Single<AuthToken>
}
