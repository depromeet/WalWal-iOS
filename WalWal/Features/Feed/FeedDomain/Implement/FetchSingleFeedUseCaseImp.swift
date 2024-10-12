//
//  FetchSingleFeedUseCaseImp.swift
//  FeedDomain
//
//  Created by 이지희 on 10/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedData
import FeedDomain

import RxSwift

public final class FetchSingleFeedUseCaseImp: FetchSingleFeedUseCase {

  private let feedRepository: FeedRepository
  
  public init(feedRepository: FeedRepository) {
    self.feedRepository = feedRepository
  }
  
  public func execute(recordId: Int) -> Single<FeedListModel> {
    return feedRepository.fetchSingleFeed(recordId: recordId)
      .map { dto in
        let feedModel = FeedListModel(dto: dto)
        return feedModel
      }
  }
}
