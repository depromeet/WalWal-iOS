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
  public private(set) var profileInfo = BehaviorRelay<GlobalProfileModel>(value: .init(nickname: "", profileURL: "", raisePet: "DOG"))
  public private(set) var feedList = BehaviorRelay<[GlobalFeedListModel]>(value: [])
  
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
  }
  
  public func updateProfileInfo(data: GlobalProfileModel) {
    profileInfo.accept(data)
  }
  
  public func fetchProfileImage(url: String) -> UIImage? {
    return imageStore[url]
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
  
  public func updateFeed(with newFeeds: [GlobalFeedListModel]) {
    var currentFeeds = feedList.value
    currentFeeds.append(contentsOf: newFeeds)
    feedList.accept(currentFeeds)
  }
  
  public func getFeeds(forDate date: String) -> [GlobalFeedListModel] {
    return feedList.value.filter {  $0.createdDate == date  }
  }
  
  public func resetFeeds() {
    feedList.accept([])
    imageStore.removeAll()
  }
  
  public func getCachedMissionImage(for feed: GlobalFeedListModel) -> UIImage? {
    guard let imageURL = feed.missionImage else { return nil }
    return imageStore[imageURL]
  }
  
  public func getCachedProfileImage(for feed: GlobalFeedListModel) -> UIImage? {
    guard let imageURL = feed.profileImage else { return nil }
    return imageStore[imageURL]
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
        let profileDownload = downloadAndCacheImage(for: feed.profileImage)
        return [missionDownload, profileDownload]
      }
      return Observable.concat(downloadTasks)
    }
  }
  
  /// 이미지를 다운로드하고 캐시에 저장하는 메서드
  public func downloadAndCacheImage(for imageUrl: String?) -> Observable<Void> {
    guard let imageUrl else { return Observable.just(()) }
    return ImageCacheManager().downloadImage(for: imageUrl)
      .withUnretained(self)
      .do(onNext: { owner, image in
        guard let image = image else { return }
        owner.imageStore[imageUrl] = image
      })
      .map { _ in }
  }
  
}
