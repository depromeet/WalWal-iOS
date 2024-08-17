//
//  LogoutUseCaseImp.swift
//  MyPageDomainImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageDomain
import LocalStorage

import RxSwift

public final class LogoutUseCaseImp: LogoutUseCase {
  
  public init() { }
  
  public func execute() -> Single<Void> {
    if UserDefaults.string(forUserDefaultsKey: .socialLogin) == "kakao" {
      return KakaoLogoutManager().kakaoLogout()
    } else {
      return .just(())
    }
  }
}
