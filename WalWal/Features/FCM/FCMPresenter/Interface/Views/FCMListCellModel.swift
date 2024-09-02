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

public struct FCMSectionModel: SectionModelType {
  public typealias Item = FCMItemModel
  var section: Int
  public var items: [Item]
  public init(section: Int, items: [Item]) {
    self.section = section
    self.items = items
  }
}

extension FCMSectionModel {
  public init(original: FCMSectionModel, items: [FCMItemModel]) {
    self = original
    self.items = items
  }
}
