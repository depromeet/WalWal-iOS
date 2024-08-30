//
//  FCMListModel.swift
//  FCMDomain
//
//  Created by Jiyeon on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMData

public struct FCMListModel: Hashable {
  public let list: [FCMItemModel]
  public let nextCursor: String?
  
  public init(dto: FCMListDTO) {
    self.list = dto.list.map { FCMItemModel(dto: $0) }
    self.nextCursor = dto.nextCursor
  }
}


public struct FCMItemModel: Hashable {
  public let notificationID: Int
  public let type: FCMTypes
  public let title: String
  public let message: String
  public let imageURL: String?
  public let isRead: Bool
  public let recordID: Int?
  public let createdAt: String
  
  public init(dto: FCMItemDTO) {
    self.notificationID = dto.notificationID
    self.type = FCMTypes(rawValue: dto.type) ?? .boost
    self.title = dto.title
    self.message = dto.message
    self.imageURL = dto.imageURL
    self.isRead = dto.isRead
    self.recordID = dto.recordID
    self.createdAt = dto.createdAt
  }
}
