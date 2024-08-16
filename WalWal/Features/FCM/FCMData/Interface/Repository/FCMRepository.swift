//
//  FCMDataRepository.swift
//  FCMData
//
//  Created by Jiyeon on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol FCMRepository {
  func fcmTokenSave(token: String) -> Single<Void>
  func fcmTokenDelete(token: String) -> Single<Void>
}
