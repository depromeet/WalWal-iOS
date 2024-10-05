//
//  ReportParameter.swift
//  FeedDataImp
//
//  Created by Jiyeon on 10/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

struct ReportParameter: Encodable {
  let recordId: Int
  let reason: String
  let details: String?
}
