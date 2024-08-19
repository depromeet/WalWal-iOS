//
//  MyPageRepositoryImp.swift
//
//  MyPage
//
//  Created by 조용인 on .
//

import Foundation
import WalWalNetwork
import MyPageData

import RxSwift

public final class MyPageRepositoryImp: MyPageRepository {
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func profileInfo() -> Single<MemberDTO> {
    let endpoint = MyPageEndPoint<MemberDTO>.myInfo
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
