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
  
  private typealias Colors = ResourceKitAsset.Colors
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  
  private let feed: WalWalFeed
  
  // MARK: - Properties
  
  private let dummyData: [WalWalFeedModel] = [ ]
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  /// WalWalCalenderDemoViewController를 초기화합니다.
  /// - Parameter walwalCalendarModels: 초기 캘린더 데이터 모델
  public init() {
    self.feed = WalWalFeed(feedData: dummyData, isFeed: true) /// isFeed에 false를 넣으면, WalWalFeed에 존재하는 CollectionView 자체의 Boost기능을 끄게 됩니다.
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
    rootView.pin.all()
    rootView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    view.addSubview(rootView)
    
    rootView.flex
      .define {
        $0.addItem(feed)
          .grow(1)
      }
  }
}
