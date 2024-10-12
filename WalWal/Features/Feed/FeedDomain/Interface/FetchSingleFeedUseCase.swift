//
//  FetchSingleFeedUseCase.swift
//  FeedDomain
//
//  Created by 이지희 on 10/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol FetchSingleFeedUseCase {
  func execute(recordId: Int) -> Single<FeedListModel>
}
