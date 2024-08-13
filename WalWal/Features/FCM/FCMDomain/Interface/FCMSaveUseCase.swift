//
//  FCMSaveUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol FCMSaveUseCase {
  func excute() -> Single<Void>
}
