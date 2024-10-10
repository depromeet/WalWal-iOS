//
//  GetCommentsUsecase.swift
//
//  Comment
//
//  Created by 조용인 on .
//

import UIKit

import RxSwift

public protocol GetCommentsUsecase {
  func execute(recordId: Int) -> Single<GetCommentsModel>
}

