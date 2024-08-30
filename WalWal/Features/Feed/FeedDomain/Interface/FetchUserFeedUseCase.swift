//
//  FetchUserFeedUseCase.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import UIKit
import GlobalState

import RxSwift

/// 특정 유저의 피드 GET
public protocol FetchUserFeedUseCase {
  func execute(memberId: Int, cursor: String?, limit: Int, isProfileFeed: Bool) -> Single<FeedModel>
}
