//
//  FeedRepository.swift
//
//  Feed
//
//  Created by 이지희 on .
//

import UIKit

import RxSwift

public protocol FeedRepository {
  func fetchFeedData(memberId: Int?, cursor: String?, limit: Int) -> Single<FeedDTO>
  func fetchSingleFeed(recordId: Int) -> Single<FeedListDTO>
}
