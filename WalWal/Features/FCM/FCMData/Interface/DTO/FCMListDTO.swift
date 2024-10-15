//
//  FCMListDTO.swift
//  FCMData
//
//  Created by Jiyeon on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public struct FCMListDTO: Decodable {
  public let list: [FCMItemDTO]
  public let nextCursor: String?
}

public struct FCMItemDTO: Decodable {
  public let notificationID: Int
  public let type: String
  public let title: String
  public let message: String
  public let imageURL: String?
  public let isRead: Bool
  public let recordID: Int?
  public let createdAt: String
  public var deepLink: String?
  
  enum CodingKeys: String, CodingKey {
    case notificationID = "notificationId"
    case type, title, message
    case imageURL = "imageUrl"
    case isRead
    case recordID = "targetId"
    case createdAt
    case deepLink
  }
}
