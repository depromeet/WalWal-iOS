//
//  KakaoUnlinkUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol KakaoUnlinkUseCase {
  func execute() -> Single<Void>
}