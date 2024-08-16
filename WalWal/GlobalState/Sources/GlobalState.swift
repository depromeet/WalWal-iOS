//
//  GlobalState.swift
//  GlobalState
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MissionDomain
import RecordsDomain

import RxSwift
import RxCocoa

public final class GlobalState {
  
  public static let shared = GlobalState()
  
  public let calendarRecords = BehaviorRelay<[MissionRecordListModel]>(value: [])
  
  private init() {}
  
  /// 캘린더 기록 추가 메서드
  public func updateCalendarRecord(with newRecords: MissionRecordListModel) {
    var currentRecords = calendarRecords.value
    currentRecords.append(newRecords)
    calendarRecords.accept(currentRecords)
  }
  
  /// 특정 날짜의 기록을 가져오는 메서드
  public func getRecords(forDate date: String) -> [MissionRecordListModel] {
    return calendarRecords.value.filter { $0.missionDate == date }
  }
}
