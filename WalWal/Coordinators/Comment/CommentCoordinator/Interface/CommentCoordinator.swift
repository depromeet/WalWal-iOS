//
//  CommentCoordinatorInterface.swift
//
//  Comment
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator

public enum CommentCoordinatorAction: ParentAction {
  case dismissComment(Int, Int) /// recordId, commentCount
  case moveToWriterPage(Int, String)
}

public enum CommentCoordinatorFlow: CoordinatorFlow {
  
}

public protocol CommentCoordinator: BaseCoordinator
where Flow == CommentCoordinatorFlow,
      Action == CommentCoordinatorAction {
  func reloadFeedAt(at recordId: Int, commentCount: Int)
  func moveToWriterPage(_ writerId: Int, _ nickmame: String)
}
