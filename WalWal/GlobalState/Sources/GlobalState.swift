//
//  GlobalState.swift
//  GlobalState
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class GlobalState {
  
  public static let shared = GlobalState()
  
  public private(set) var calendarRecords = BehaviorRelay<[GlobalMissonRecordListModel]>(value: [])
  
  private init() {}
  
  /// 캘린더 기록 추가 메서드
  public func updateCalendarRecord(with newRecords: [GlobalMissonRecordListModel]) {
    var currentRecords = calendarRecords.value
    currentRecords.append(contentsOf: newRecords)
    calendarRecords.accept(currentRecords)
  }
  
  /// 특정 날짜의 기록을 가져오는 메서드
  public func getRecords(forDate date: String) -> [GlobalMissonRecordListModel] {
    return calendarRecords.value.filter { $0.missionDate == date }
  }
  
  /// 캘린더 기록 초기화 (cursor를 불러올 때 처음부터 불러오니까 일단 비워야함)
  public func resetRecords() {
    calendarRecords = BehaviorRelay<[GlobalMissonRecordListModel]>(value: [])
  }
}
