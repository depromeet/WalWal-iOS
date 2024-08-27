//
//  WalWalCalendar.swift
//  DesignSystem
//
//  Created by 조용인 on 7/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public final class WalWalCalendar: UIView {
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  
  private let headerContainer = UIView()
  private let headerView = WalWalCalendarHeaderView()
  
  private let weekdayContainer = UIView()
  private let weekdayView = WalWalCalendarWeekdayView()
  
  private let monthContainer = UIView()
  private let monthView: WalWalCalendarMonthView
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  /// 외부에서 Calendar에 WalWalCalendarModel을 주입하기 위한 Relay
  public let walwalCalendarModels = PublishRelay<[WalWalCalendarModel]>()
  
  /// 선택된 날짜에 대한 정보를 전달하기 위한 Relay
  public let selectedDayData = PublishRelay<WalWalCalendarModel>()
  
  // MARK: - Initializers
  
  /// WalWalCalendar를 초기화합니다.
  /// - Parameter initialModels: 초기 캘린더 데이터 모델
  public init(
    initialModels: [WalWalCalendarModel] = []
  ) {
    self.monthView = WalWalCalendarMonthView(cellDatas: initialModels)
    super.init(frame: .zero)
    setLayouts()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    rootContainer.flex
      .layout()
  }
  
  // MARK: Methods
  
  private func setLayouts() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .define { flex in
      flex.addItem(headerContainer)
        .marginTop(18.adjusted)
      flex.addItem(weekdayContainer)
        .marginTop(10.adjusted)
      flex.addItem(monthContainer)
        .marginTop(4.adjusted)
        .marginHorizontal(20.adjusted)
        .grow(1)
        .shrink(1)
    }
    
    headerContainer.flex
      .define { flex in
      flex.addItem(headerView)
        .height(44.adjusted)
        .grow(1)
        .shrink(1)
        .alignSelf(.center)
    }
    
    weekdayContainer.flex
      .alignSelf(.center)
      .define { flex in
      flex.addItem(weekdayView)
        .width(100%)
        .height(44.adjusted)
    }
    
    monthContainer.flex
      .define { flex in
      flex.addItem(monthView)
        .width(100%)
        .height(100%)
    }
  }
  
  private func bind() {
    headerView.rx.monthChanged
      .bind(to: monthView.monthChangedSubject)
      .disposed(by: disposeBag)
    
    walwalCalendarModels
      .subscribe(with: self, onNext: { owner, month in
        owner.updateMonthView(with: month)
      })
      .disposed(by: disposeBag)
    
    monthView.rx.selectedCell
      .compactMap { $0 }
      .bind(to: selectedDayData)
      .disposed(by: disposeBag)
  }
  
  private func updateMonthView(with models: [WalWalCalendarModel]) {
    monthView.updateCellDatas(models)
  }
}

// MARK: - Reactive Extension

public extension Reactive where Base: WalWalCalendar {
  /// 선택된 날짜 데이터를 관찰합니다.
  var selectedDay: ControlEvent<WalWalCalendarModel> {
    ControlEvent(events: base.selectedDayData)
  }
  
  /// 캘린더 모델을 업데이트합니다.
  var updateModels: Binder<[WalWalCalendarModel]> {
    Binder(base) { calendar, models in
      calendar.walwalCalendarModels.accept(models)
    }
  }
}
