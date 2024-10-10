//
//  CommentRepository.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift

public protocol CommentRepository {
  func getComments(recordId: Int) -> Single<GetCommentsDTO>
  func postComment(content: String, recordId: Int, parentId: Int?) -> Single<PostCommentDTO>
}
