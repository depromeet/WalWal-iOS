//
//  WalWalFeedViewController.swift
//  DesignSystem
//
//  Created by 이지희 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import RxGesture

final class WalWalFeedViewController: UIViewController {
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = UIColor(hex: 0xF7F8FA)
  }
  
  private let feed: WalWalFeed
  
  // MARK: - Properties
  
  private let dummyData: [WalWalFeedModel] = [
    .init(nickname: "찐찐도그",
          missionTitle: "산책 미션을 수행했어요!",
          profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
          missionImage: ResourceKitAsset.Sample.feedSample.image,
          boostCount: 324),
    .init(nickname: "찐찐도그",
          missionTitle: "산책 미션을 수행했어요!",
          profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
          missionImage: ResourceKitAsset.Sample.feedSample.image,
          boostCount: 324),
    .init(nickname: "찐찐도그",
          missionTitle: "산책 미션을 수행했어요!",
          profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
          missionImage: ResourceKitAsset.Sample.feedSample.image,
          boostCount: 324)
  ]
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  /// WalWalCalenderDemoViewController를 초기화합니다.
  /// - Parameter walwalCalendarModels: 초기 캘린더 데이터 모델
  public init() {
    self.feed = WalWalFeed(feedData: dummyData)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayouts()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootView.pin.all(view.pin.safeArea)
    rootView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setAttributes() {
    view.backgroundColor = .white
  }
  
  private func setLayouts() {
    view.addSubview(rootView)
    
    rootView
      .flex
      .define {
        $0.addItem(feed)
          .grow(1)
      }
  }
  
//  private func bind() {
//    calendar.selectedDayData
//      .subscribe(with: self, onNext: { owner, data in
//        owner.showAlert(with: data)
//      })
//      .disposed(by: disposeBag)
//  }
}