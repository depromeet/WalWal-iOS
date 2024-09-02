//
//  FCMListUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol FCMListUseCase {
  func execute(cursor: String?, limit: Int) -> Single<FCMListModel>
}
