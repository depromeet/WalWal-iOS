//
//  LogoutUseCase.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol LogoutUseCase {
  func execute() -> Single<Void>
}
