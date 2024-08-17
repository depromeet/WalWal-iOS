//
//  WithdrawUseCase.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageData
import MyPageDomain

import RxSwift

public final class WithdrawUseCaseImp: WithdrawUseCase {
  
  private let mypageRepository: MyPageRepository
  
  public init(mypageRepository: MyPageRepository) {
    self.mypageRepository = mypageRepository
  }
  
  public func execute() -> Single<Void> {
    if UserDefaults.string(forUserDefaultsKey: .socialLogin) == "kakao" {
      return KakaoLogoutManager().kakaoUnlink()
        .flatMap {
          self.mypageRepository.withdraw()
        }
    } else {
      return mypageRepository.withdraw()
    }
    
  }
}
