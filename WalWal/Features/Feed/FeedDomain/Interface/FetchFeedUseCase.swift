//
//  FetchFeedUseCase.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift

public protocol FetchFeedUseCase {
  func excute(cursor: String, limit: Int) -> Single<FeedModel>
}

