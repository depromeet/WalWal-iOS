//
//  GlobalState.swift
//  GlobalState
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa
import Kingfisher

public final class GlobalState {
  
  public static let shared = GlobalState()
  
  public private(set) var calendarRecords = BehaviorRelay<[GlobalMissonRecordListModel]>(value: [])
  /// 이미지 저장소 (캐시된 이미지를 저장하는 딕셔너리)
  public private(set) var imageStore: [String: UIImage] = [:]
  
  private let disposeBag = DisposeBag()
  
  private init() {
    bind()
  }
  
  private func bind() {
    /// calendarRecords가 변경될 때마다 이미지를 다운로드
    calendarRecords
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, records -> Observable<Void> in
        return owner.preloadImages()
      }
      .subscribe()
      .disposed(by: disposeBag)
  }
  
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
    calendarRecords.accept([])
    imageStore.removeAll() /// 이미지도 초기화
  }
  
  /// 특정 기록에 대한 이미지를 반환하는 메서드 (캐시된 이미지가 없으면 nil 반환)
  public func getCachedImage(for record: GlobalMissonRecordListModel) -> UIImage? {
    return imageStore[record.imageUrl]
  }
  
  /// 이미지 미리 불러오기 메서드
  private func preloadImages() -> Observable<Void> {
    let downloadTasks = self.calendarRecords.value.map { record in
      return downloadAndCacheImage(for: record)
    }
    return Observable.concat(downloadTasks) /// 모든 다운로드 작업을 순차적으로 실행
  }
  
  /// 이미지를 다운로드하고 캐시하는 메서드
  private func downloadAndCacheImage(for record: GlobalMissonRecordListModel) -> Observable<Void> {
    return Observable.create { observer in
      let url = URL(string: record.imageUrl)
      guard let url = url else {
        observer.onNext(())
        observer.onCompleted()
        return Disposables.create()
      }
      
      /// Kingfisher를 사용해 이미지 다운로드 및 캐싱
      let resource = KF.ImageResource(downloadURL: url)
      KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
        guard let owner = self else {
          observer.onCompleted()
          return
        }
        switch result {
        case .success(let value):
          /// 다운로드된 이미지를 캐시 저장소에 저장 (key로써 imageUrl을 사용허자~)
          owner.imageStore[record.imageUrl] = value.image
          observer.onNext(())
        case .failure(let error):
          print("""
            - 😵 Kingfisher 이미지 다운로드 실패
            - 😵 imageUrl: \(record.imageUrl)
            - 😵 error: \(error)
            """)
          
          observer.onNext(())
        }
        observer.onCompleted()
      }
      
      return Disposables.create()
    }
  }
}
