//
//  SocialLoginUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol SocialLoginUseCase {
  /// 소셜 로그인 메서드
  ///
  /// - Parameters:
  ///   - provider: 소셜 로그인 타입 (.apple, .kakao)
  ///   - token: apple - authcode / kakao - accesstoken
  func execute(provider: ProviderType, token: String) -> Single<AuthToken>
}
