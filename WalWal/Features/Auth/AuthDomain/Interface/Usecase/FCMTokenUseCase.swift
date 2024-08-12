//
//  FCMTokenUseCase.swift
//  AuthDomain
//
//  Created by Jiyeon on 8/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol FCMTokenUseCase {
  func excute() -> Single<Void>
}
