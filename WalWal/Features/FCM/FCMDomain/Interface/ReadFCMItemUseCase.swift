//
//  ReadFCMItemUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol ReadFCMItemUseCase {
  func execute(id: Int) -> Single<Void>
}
