//
//  CheckTokenUsecaseImp.swift
//  SplashDomainImp
//
//  Created by 조용인 on 8/9/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import LocalStorage
import SplashDomain


import RxSwift

public final class CheckTokenUsecaseImp: CheckTokenUsecase {
  
  public init() {
     
  }
  
  public func execute() -> String? {
    KeychainWrapper.shared.accessToken
  }
}
