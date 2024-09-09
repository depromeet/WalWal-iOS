//
//  FCMListCellModel.swift
//  FCMPresenter
//
//  Created by Jiyeon on 8/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMDomain

import RxDataSources

public enum FCMSection {
  case today(item: [FCMItems])
  case last(item: [FCMItems])
}

public enum FCMItems {
  case fcmItems(reactor: FCMCellReactor)
}

extension FCMSection: SectionModelType {
  
  public var items: [FCMItems] {
    switch self {
    case .today(let item):
      return item
    case .last(let item):
      return item
    }
  }
  
  public init(original: FCMSection, items: [FCMItems]) {
    switch original {
    case .today(let item):
      self = .today(item: item)
    case .last(let item):
      self = .last(item: item)
    }
  }
}
