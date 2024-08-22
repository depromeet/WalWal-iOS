//
//  FetchFeedUseCase.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import GlobalState

import RxSwift

public protocol FetchFeedUseCase {
  func execute(memberId: Int?, cursor: String?, limit: Int) -> Single<FeedModel>
}
