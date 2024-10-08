//
//  ReportType.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public enum ReportType: CaseIterable {
  case imposture
  case notPet
  case violence
  case advertisement
  case adult
  case etc
}

extension ReportType {
  public var title: String {
    switch self {
    case .imposture:
      return "사기 또는 사칭"
    case .notPet:
      return "반려동물이 아님"
    case .violence:
      return "폭력, 혐오 또는 학대"
    case .advertisement:
      return "광고, 홍보, 스팸"
    case .adult:
      return "성인용 콘텐츠"
    case .etc:
      return "기타"
    }
  }
}
