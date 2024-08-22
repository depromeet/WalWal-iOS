//
//  FetchMissionUseCase.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import FeedData
import FeedDomain

import GlobalState

import RxSwift

public final class FetchFeedUseCaseImp: FetchFeedUseCase {

  private let feedRepository: FeedRepository
  
  public init(feedRepository: FeedRepository) {
    self.feedRepository = feedRepository
  }
  
  public func execute(memberId: Int? = nil, cursor: String?, limit: Int) -> Single<FeedModel> {
    return feedRepository.fetchFeedData(memberId: memberId, cursor: cursor, limit: limit)
      .map { dto in
        let feedModel = FeedModel(dto: dto)
        feedModel.saveToGlobalState()
        return feedModel
      }
  }
}
