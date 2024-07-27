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
  
  private let headerView = WalWalCalendarHeaderView()
  
  private let weekdayView = WalWalCalendarWeekdayView()
  
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
    flex.layout()
  }
  
  // MARK: Methods
  
  private func setLayouts() {
    flex
      .direction(.column)
      .padding(Const.horizontalPadding)
      .define { flex in
        flex
          .addItem(headerView)
          .width(Const.headerWidth)
          .height(Const.headerHeight)
          .alignSelf(.center)
          .marginTop(Const.headerMarginTop)
        flex
          .addItem(weekdayView)
          .width(100%)
          .height(Const.weekdayHeight)
        flex
          .addItem(monthView)
          .width(100%)
          .grow(1)
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

// MARK: - WalWalCalendar Extension
private extension WalWalCalendar {
  enum Const {
    static let horizontalPadding: CGFloat = 20
    static let headerWidth: CGFloat = 200
    static let headerHeight: CGFloat = 44
    static let headerMarginTop: CGFloat = 28
    static let weekdayHeight: CGFloat = 30
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
