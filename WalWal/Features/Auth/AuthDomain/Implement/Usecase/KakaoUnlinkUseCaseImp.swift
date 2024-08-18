//
//  KakaoUnlinkUseCaseImp.swift
//  AuthDomainImp
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import AuthDomain

import RxSwift

public final class KakaoUnlinkUseCaseImp: KakaoUnlinkUseCase {
  public init() { }
  public func execute() -> Single<Void> {
    return KakaoLoginManager().kakaoUnlink()
  }
}
