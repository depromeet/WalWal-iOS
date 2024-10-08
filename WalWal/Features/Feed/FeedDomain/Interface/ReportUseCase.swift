//
//  ReportUseCase.swift
//  FeedDomain
//
//  Created by Jiyeon on 10/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol ReportUseCase {
  func execute(recordId: Int, type: String, details: String?) -> Single<Void>
}
