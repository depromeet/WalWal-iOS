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
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  private let rootContainer = UIView()
  
  private let leftButtonContainer = UIView()
  private let centerLabelContainer = UIView()
  private let rightButtonContainer = UIView()
  
  private let monthLabel = CustomLabel(font: Fonts.KR.H6.B).then {
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  
  private let prevButton = WalWalTouchArea(
    image: Images.backS.image.withTintColor(Colors.gray500.color),
    size: 20
  ).then {
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
  }
  
  private let nextButton = WalWalTouchArea(
    image: Images.backS.image.rotate(radians: .pi)?.withTintColor(Colors.gray500.color),
    size: 20
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
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .direction(.row)
      .define { flex in
        flex.addItem(leftButtonContainer)
          .size(20)
        flex.addItem(centerLabelContainer)
          .marginHorizontal(16)
        flex.addItem(rightButtonContainer)
          .size(20)
      }
    
    leftButtonContainer.flex
      .define { flex in
        flex.addItem(prevButton)
          .width(100%)
          .height(100%)
          .alignSelf(.center)
      }
    
    centerLabelContainer.flex
      .define { flex in
        flex.addItem(monthLabel)
      }
    
    rightButtonContainer.flex.define { flex in
      flex.addItem(nextButton)
        .width(100%)
        .height(100%)
        .alignSelf(.center)
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
