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


public final class FetchFeedUseCaseImp: FetchFeedUseCase{

  private let feedRepository: FeedRepository
  
  public init(feedRepository: FeedRepository) {
    self.feedRepository = feedRepository
  }
  
  public func execute(cursor: String, limit: Int) -> Single<FeedModel> {
    return feedRepository.fetchFeedData(cursor: cursor, limit: limit)
      .map{
        let feedModel = FeedModel(dto: $0)
        feedModel.saveToGlobalState()
        return feedModel
      }
  }

  
}

