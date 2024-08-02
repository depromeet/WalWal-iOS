//
//  WalWalCalendarHeaderView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import RxGesture
import Then
import FlexLayout
import PinLayout

final class WalWalCalendarHeaderView: UIView {
  
  // MARK: - UI
  private let containerView = UIView()
  
  private let monthLabel = UILabel().then {
    $0.font = ResourceKitFontFamily.KR.H6.B
    $0.textColor = ResourceKitAsset.Colors.black.color
    $0.textAlignment = .center
  }
  
  private let prevButton = WalWalTouchArea(
    image: ResourceKitAsset.Assets._16x16PrevButton.image,
    size: 16
  ).then {
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
  }
  
  private let nextButton = WalWalTouchArea(
    image: ResourceKitAsset.Assets._16x16NextButton.image,
    size: 16
  ).then {
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
  }
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  private let currentDate = BehaviorRelay<Date>(value: Date())
  
  fileprivate let monthChangedSubject = PublishSubject<Date>()
  
  fileprivate let calendarShouldScrollSubject = PublishSubject<Void>()
  
  // MARK: - Initializers
  
  init() {
    super.init(frame: .zero)
    setLayouts()
    bind()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    addSubview(containerView)
    
    containerView
      .flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(prevButton)
          .size(Const.buttonSize)
        flex.addItem(monthLabel)
          .grow(1)
          .shrink(1)
        flex.addItem(nextButton)
          .size(Const.buttonSize)
      }
  }
  
  private func bind() {
    Observable.merge(
      prevButton.rx.tapped.map { _ in -1 },
      nextButton.rx.tapped.map { _ in 1 }
    )
    .subscribe(with: self, onNext: { owner, value in
      owner.changeMonth(by: value)
    })
    .disposed(by: disposeBag)
    
    currentDate
      .map { Const.dateFormatter.string(from: $0) }
      .bind(to: monthLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func changeMonth(by value: Int) {
    guard let newDate = Calendar.current.date(
      byAdding: .month,
      value: value,
      to: currentDate.value
    ) else { return }
    
    currentDate.accept(newDate)
    monthChangedSubject.onNext(newDate)
    calendarShouldScrollSubject.onNext(())
  }
}

// MARK: - WalWalCalendarHeaderView Extension

private extension WalWalCalendarHeaderView {
  enum Const {
    static let buttonSize: CGFloat = 44
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy년 M월"
      return formatter
    }()
  }
}

// MARK: - Reactive Extension
extension Reactive where Base: WalWalCalendarHeaderView {
  var monthChanged: ControlEvent<Date> {
    ControlEvent(events: base.monthChangedSubject)
  }
  
  var calendarShouldScroll: ControlEvent<Void> {
    ControlEvent(events: base.calendarShouldScrollSubject)
  }
}
