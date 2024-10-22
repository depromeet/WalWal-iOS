//
//  GlobalState.swift
//  GlobalState
//
//  Created by 조용인 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import UIKit
import Utility
import ResourceKit

import RxSwift
import RxCocoa
import Kingfisher

public final class GlobalState {
  
  public static let shared = GlobalState()
  
  public private(set) var calendarRecords = BehaviorRelay<[GlobalMissonRecordListModel]>(value: [])
  public private(set) var profileInfo = BehaviorRelay<GlobalProfileModel>(value: .init(memberId: 0, nickname: "", profileURL: "INACTIVE_DOG", raisePet: "DOG"))
  public private(set) var feedList = BehaviorRelay<[GlobalFeedListModel]>(value: [])
  public private(set) var recordList = BehaviorRelay<[GlobalFeedListModel]>(value: [])
  public let fcmList = BehaviorRelay<[GlobalFCMListModel]>(value: [])
  public let moveToFeedRecord = BehaviorRelay<(Int?, Int?)?>(value: nil)
  
  /// 이미지 저장소 (캐시된 이미지를 저장하는 딕셔너리)
  public private(set) var imageStore = NSCache<NSString, UIImage>()
  
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
        return owner.preloadImages(globalState: .missonRecordList)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    profileInfo
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, info -> Observable<Void> in
        if DefaultProfile(rawValue: info.profileURL) == nil {
          return owner.preloadImages(globalState: .profile(info.profileURL))
        }
        return .empty()
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    feedList
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feeds -> Observable<Void> in
        return owner.preloadImages(globalState: .feedList)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    recordList
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feed -> Observable<Void> in
        return owner.preloadImages(globalState: .recodList(owner.profileInfo.value.memberId))
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    fcmList
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, data -> Observable<Void> in
        return owner.preloadImages(globalState: .fcmList)
      }
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  // MARK: - Save RecordID
  
  public func updateRecordId(_ recordId: Int?, commentId: Int? = nil) {
    moveToFeedRecord.accept((recordId, commentId))
  }
  
  // MARK: - Profile
  
  public func updateProfileInfo(data: GlobalProfileModel) {
    profileInfo.accept(data)
  }
  
  public func fetchProfileImage(url: String) -> UIImage? {
    return imageStore.object(forKey: url as NSString)
  }
  
  // MARK: - Calendar
  
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
    imageStore.removeAllObjects() /// 이미지도 초기화
  }
  
  /// 특정 기록에 대한 이미지를 반환하는 메서드 (캐시된 이미지가 없으면 nil 반환)
  public func getCachedImage(for record: GlobalMissonRecordListModel) -> UIImage? {
    guard let imageURL = record.imageUrl else { return nil }
    return imageStore.object(forKey: imageURL as NSString)
  }
  
  // MARK: - Feed
  
  /// 피드 정보 업데이트
  public func updateFeed(with newFeeds: [GlobalFeedListModel]) {
    var currentFeeds = feedList.value
    let newUniqueFeeds = newFeeds.filter { newFeed in
      !currentFeeds.contains(where: { $0.recordID == newFeed.recordID }) // 중복 검사 (id가 같으면 중복)
    }
    currentFeeds.append(contentsOf: newUniqueFeeds)
    feedList.accept(currentFeeds)
  }
  
  /// 피드 가져오기
  public func getFeeds(forDate date: String) -> [GlobalFeedListModel] {
    return feedList.value.filter {  $0.createdDate == date  }
  }
  
  // MARK: - Record
  
  /// 기록 정보 업데이트
  public func updateRecords(with newRecords: [GlobalFeedListModel]) {
    var currentRecord = recordList.value
    let newUniqueRecords = newRecords.filter { newRecord in
      !currentRecord.contains(where: { $0.recordID == newRecord.recordID }) // 중복 검사 (id가 같으면 중복)
    }
    currentRecord.append(contentsOf: newUniqueRecords)
    recordList.accept(currentRecord)
  }
  
  /// 기록 가져오기
  public func getRecords(forDate date: String) -> [GlobalFeedListModel] {
    return recordList.value.filter {  $0.createdDate == date  }
  }
  
  // MARK: - FCM List
  
  /// FCM List 업데이트
  public func updateFCMList(newList: [GlobalFCMListModel]) {
    var curList = fcmList.value
    let newItems = newList.filter { item in
      !curList.contains(where: { $0.notificationID == item.notificationID })
    }
    curList.append(contentsOf: newItems)
    fcmList.accept(curList)
  }
  
  /// FCM 데이터 지우기
  public func removeRecords() {
    fcmList.accept([])
  }
  
  // MARK: - Image
  
  public func getCachedMissionImage(for feed: GlobalFeedListModel) -> UIImage? {
    guard let imageURL = feed.missionImage else { return nil }
    return imageStore.object(forKey: imageURL as NSString)
  }
  
  public func getCachedProfileImage(for feed: GlobalFeedListModel) -> UIImage? {
    guard let imageURL = feed.profileImage else { return nil }
    return imageStore.object(forKey: imageURL as NSString)
  }
  
  /// 이미지 미리 불러오기 메서드
  private func preloadImages(globalState: GlobalStateType) -> Observable<Void> {
    switch globalState {
    case .missonRecordList:
      let downloadTasks = self.calendarRecords.value.map { record in
        return downloadAndCacheImage(for: record.imageUrl)
      }
      return Observable.concat(downloadTasks) /// 모든 다운로드 작업을 순차적으로 실행
    case let .profile(url):
      return downloadAndCacheImage(for: url)
    case .feedList:
      let downloadTasks = self.feedList.value.flatMap { feed -> [Observable<Void>] in
        let missionDownload = downloadAndCacheImage(for: feed.missionImage)
          .catchAndReturn(())
        let profileDownload = downloadAndCacheImage(for: feed.profileImage)
          .catchAndReturn(())
        return [missionDownload, profileDownload]
      }
      return Observable.concat(downloadTasks)
    case .recodList(_):
      let downloadTasks = self.recordList.value.flatMap { record -> [Observable<Void>] in
        let missionDownload = downloadAndCacheImage(for: record.missionImage)
          .catchAndReturn(())
        let profileDownload = downloadAndCacheImage(for: record.profileImage, isSmallImage: true)
          .catchAndReturn(())
        return [missionDownload, profileDownload]
      }
      return Observable.concat(downloadTasks)
    case .fcmList:
      let tasks = self.fcmList.value.map { data in
        return downloadAndCacheImage(for: data.imageURL)
      }
      return Observable.concat(tasks)
    }
  }
  
  /// 이미지를 다운로드하고 캐시에 저장하는 메서드
  public func downloadAndCacheImage(for imageUrl: String?, isSmallImage: Bool = false) -> Observable<Void> {
    guard let imageUrl else { return Observable.just(()) }
    return ImageCacheManager.shared.downloadImage(for: imageUrl, isSmallImage: isSmallImage)
      .withUnretained(self)
      .do(onNext: { owner, image in
        guard let image = image else { return }
        owner.imageStore.setObject(image, forKey: imageUrl as NSString)
      })
      .map { _ in }
  }
  
}
