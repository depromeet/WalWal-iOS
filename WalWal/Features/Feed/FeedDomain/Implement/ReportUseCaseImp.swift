//
//  ReportUseCaseImp.swift
//  FeedDomainImp
//
//  Created by Jiyeon on 10/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedData
import FeedDomain

import RxSwift

public final class ReportUseCaseImp: ReportUseCase {
  private let reportRepository: ReportRepository
  
  public init(reportRepository: ReportRepository) {
    self.reportRepository = reportRepository
  }
  public func execute(recordId: Int, type: String, details: String?) -> Single<Void> {
    return reportRepository.reportRequest(recordId: recordId, type: type, details: details)
  }
}
