//
//  CheckIsFirstLoadedUseCaseImp.swift
//  SplashDomainImp
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import LocalStorage
import SplashDomain

import RxSwift

public final class CheckIsFirstLoadedUseCaseImp: CheckIsFirstLoadedUseCase {
  
  public init() {
    
  }
  
  public func execute() -> Observable<Bool> {
    let isFirstLoaded = UserDefaults.bool(forUserDefaultsKey: .isFirstLoaded)
    if isFirstLoaded {
      let _ = KeychainWrapper.shared.setAccessToken(nil)
    }
    return .just(isFirstLoaded)
  }
}
