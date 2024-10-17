//
//  SaveFCMListGlobalStateUseCaseImp.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMDomain
import GlobalState

public class SaveFCMListGlobalStateUseCaseImp: SaveFCMListGlobalStateUseCase {
  
  public init() { }
  
  public func execute(
    fcmList: FCMListModel,
    globalState: GlobalState
  ) {
    let globalList = fcmList.list.map {
      return GlobalFCMListModel(
        notificationID: $0.notificationID,
        type: $0.type.rawValue,
        title: $0.title,
        message: $0.message,
        imageURL: $0.imageURL,
        isRead: $0.isRead,
        recordID: $0.recordID,
        createdAt: $0.createdAt,
        commentId: $0.commentId
      )
    }
    globalState.updateFCMList(newList: globalList)
    
  }
}
