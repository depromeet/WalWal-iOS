//
//  CommentRepository.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import CommentData

import RxSwift

public final class CommentRepositoryImp: CommentRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func getComments(recordId: Int) -> Single<GetCommentsDTO> {
    let body = GetCommentsBody(recordId: recordId)
    let endpoint = CommentEndpoint<GetCommentsDTO>.getComments(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
  
  public func postComment(content: String, recordId: Int, parentId: Int?) -> Single<PostCommentDTO> {
    let body = PostCommentsBody(content: content, recordId: recordId, parentId: parentId)
    let endpoint = CommentEndpoint<PostCommentDTO>.postComments(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
