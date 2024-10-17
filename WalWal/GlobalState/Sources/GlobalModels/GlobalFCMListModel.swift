//
//  GlobalFCMListModel.swift
//  GlobalState
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct GlobalFCMListModel {
  public let notificationID: Int
  public let type: String
  public let title: String
  public let message: String
  public let imageURL: String?
  public let isRead: Bool
  public let recordID: Int?
  public let createdAt: String
  public let commentId: Int?
  
  public init(
    notificationID: Int,
    type: String,
    title: String,
    message: String,
    imageURL: String?,
    isRead: Bool,
    recordID: Int?,
    createdAt: String,
    commentId: Int?
  ) {
    self.notificationID = notificationID
    self.type = type
    self.title = title
    self.message = message
    self.imageURL = imageURL
    self.isRead = isRead
    self.recordID = recordID
    self.createdAt = createdAt
    self.commentId = commentId
  }
}
