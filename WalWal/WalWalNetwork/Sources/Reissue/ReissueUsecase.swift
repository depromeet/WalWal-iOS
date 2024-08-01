//
//  ReissueUsecase.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

final class ReissueUsecase {
  
  private let reissueRepository: ReissueRepository
  
  init(reissueRepository: ReissueRepository) {
    self.reissueRepository = reissueRepository
  }
  
  public func excute(refreshToken : String) -> Single<Token> {
    return reissueRepository.reissue(refreshToken: refreshToken)
      .map { Token(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
      .asObservable()
      .asSingle()
  }
}


struct Token {
  let accessToken: String
  let refreshToken: String
}
