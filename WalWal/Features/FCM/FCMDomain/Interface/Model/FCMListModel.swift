//
//  FCMListModel.swift
//  FCMDomain
//
//  Created by Jiyeon on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import FCMData
import GlobalState

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
  public var isRead: Bool
  public let recordID: Int?
  public let createdAt: String
  public var image: UIImage?
  public var commentId: Int?
  
  public init(dto: FCMItemDTO) {
    let type = FCMTypes(rawValue: dto.type) ?? .boost
    
    self.notificationID = dto.notificationID
    self.type = type
    self.title = dto.title
    self.message = dto.message
    self.imageURL = dto.imageURL
    self.isRead = dto.isRead
    self.recordID = dto.recordID
    self.createdAt = dto.createdAt
    self.commentId = checkCommentId(type: type, link: dto.deepLink)
  }
  public init(global: GlobalFCMListModel) {
    self.notificationID = global.notificationID
    self.type = FCMTypes(rawValue: global.type) ?? .boost
    self.title = global.title
    self.message = global.message
    self.imageURL = global.imageURL
    self.isRead = global.isRead
    self.recordID = global.recordID
    self.createdAt = global.createdAt
    self.image = GlobalState.shared.imageStore.object(forKey: (global.imageURL ?? "") as NSString)
    self.commentId = global.commentId
  }
}

extension FCMItemModel {
  private func checkCommentId(type: FCMTypes, link: String?) -> Int? {
    
    guard type == .comment || type == .recomment,
          let link = link,
          let url = URL(string: link)
    else { return nil }
    
    let urlString = url.absoluteString
    guard urlString.contains("commentId") else { return nil }
    let components = URLComponents(string: urlString)
    
    let urlQueryItems = components?.queryItems ?? []
    var dictionaryData = [String: String]()
    urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }
    
    guard let id = dictionaryData["commentId"],
            let commentId = Int(id)
    else { return nil }
    
    return commentId
  }
}
