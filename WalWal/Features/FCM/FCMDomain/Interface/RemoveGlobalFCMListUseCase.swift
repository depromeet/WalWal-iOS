//
//  RemoveGlobalFCMListUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol RemoveGlobalFCMListUseCase {
  func execute() -> Single<Void>
}
