//
//  CheckIsFirstLoadedUseCase.swift
//  SplashDomain
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol CheckIsFirstLoadedUseCase {
  /// 앱 설치 이후 최초 접속인지 체크합시당
  func execute() -> Observable<Bool>
}
