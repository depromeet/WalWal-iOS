//
//  KakaoLoginUseCaseImp.swift
//  AuthDomainImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain

import RxSwift

public final class KakaoLoginUseCaseImp: KakaoLoginUseCase {
  
  public init() { }
  
  public func execute() -> Single<String> {
    return KakaoLoginManager().kakaoLogin()
  }
}
