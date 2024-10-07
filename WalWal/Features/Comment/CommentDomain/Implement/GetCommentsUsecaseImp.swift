//
//  GetCommentsUsecaseImp.swift
//
//  Comment
//
//  Created by 조용인 on .
//

import UIKit
import CommentData
import CommentDomain

import RxSwift

public final class GetCommentsUsecaseImp: GetCommentsUsecase {
  public let repository: CommentRepository
  
  public init(repository: CommentRepository) {
    self.repository = repository
  }
  
  public func excute(recordId: Int) -> Single<GetCommentsModel> {
    return repository.getComments(recordId: recordId)
      .map { GetCommentsModel(dto: $0) }
  }
}

