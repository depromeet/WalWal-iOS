//
//  FetchWalWalFeedUseCase.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import RxSwift

public protocol FetchWalWalFeedUseCase {
  func execute() -> Observable<[GlobalFeedListModel]>
}
