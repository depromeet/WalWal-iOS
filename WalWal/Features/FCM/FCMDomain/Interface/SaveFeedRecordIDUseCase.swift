//
//  SaveFeedRecordIDUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import RxSwift

public protocol SaveFeedRecordIDUseCase {
  func execute(recordId: Int?, commentId: Int?) -> Observable<Void>
}
