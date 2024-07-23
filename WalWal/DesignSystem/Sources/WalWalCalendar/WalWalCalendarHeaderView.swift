//
//  WalWalCalendarHeaderView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Then
import FlexLayout
import PinLayout

final public class WalWalCalendarHeaderView: UIView {
  
  private let containerView = UIView()
  
  private let monthLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let prevButton = UIImageView().then {
    $0.image = UIImage(systemName: "chevron.left")
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .black
    $0.isUserInteractionEnabled = true
  }
  
  private let nextButton = UIImageView().then {
    $0.image = UIImage(systemName: "chevron.right")
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .black
    $0.isUserInteractionEnabled = true
  }
  
  private let disposeBag = DisposeBag()
  private let currentDate = BehaviorRelay<Date>(value: Date())
  private let monthChangedSubject = PublishSubject<Date>()
  private let calendarShouldScrollSubject = PublishSubject<Void>()
  
  
  /// WalWalCalendarHeaderView의 생성자입니다. ( 파라미터는 추후 추가 )
  /// - Parameter :
  public init() {
    super.init(frame: .zero)
    setLayout()
    bind()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is called.")
  }
  
  private func setLayout() {
    addSubview(containerView)
    
    containerView.flex.direction(.row).justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(prevButton).width(16).height(16).marginLeft(14)
      flex.addItem(monthLabel).grow(1).shrink(1)
      flex.addItem(nextButton).width(16).height(16).marginRight(14)
    }
  }
  
  private func bind() {
    prevButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.changeMonth(prev: true)
      })
      .disposed(by: disposeBag)
    
    nextButton.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        owner.changeMonth(prev: false)
      })
      .disposed(by: disposeBag)
    
    currentDate
      .map { date -> String in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
      }
      .bind(to: monthLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func changeMonth(prev isMinus: Bool) {
    let value = isMinus ? -1 : 1
    guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate.value) else { return }
    currentDate.accept(newDate)
    
    monthChangedSubject.onNext(newDate)
    calendarShouldScrollSubject.onNext(())
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.top(12).bottom(12).width(100%).height(100%)
    containerView.flex.layout(mode: .adjustHeight)
  }
}
