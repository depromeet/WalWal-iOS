//
//  CheckTokenUsecase.swift
//  SplashDomain
//
//  Created by 조용인 on 8/9/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol CheckTokenUsecase {
  /// AccessToken 존재 유무 판별
  func execute() -> String?
}
