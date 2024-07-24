//
//  WalWalCalendarMonthView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public class WalWalCalendarMonthView: UIView {
  
  // MARK: - UI
  
  private let collectionView: UICollectionView
  
  // MARK: - Properties
  
  private var currentMonth: Date
  
  private var today: Date
  
  public let monthChangedSubject = PublishSubject<Date>()
  
  private let dateRelay: BehaviorRelay<[Date]> = BehaviorRelay(value: [])
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  // MARK: - LifeCycle
  
  // MARK: - Methods
  
  public init(
    initialDate: Date = Date()
  ) {
    self.currentMonth = initialDate
    self.today = Calendar.current.startOfDay(for: Date())
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 6
    layout.minimumLineSpacing = 24
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(frame: .zero)
    
    setLayout()
    bind()
    updateDates()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setLayout() {
    addSubview(collectionView)
    collectionView.register(WalWalCalendarDayCell.self, forCellWithReuseIdentifier: "DayCell")
    collectionView.backgroundColor = .white
  }
  
  private func bind() {
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    dateRelay
      .bind(to: collectionView.rx.items(cellIdentifier: "DayCell", cellType: WalWalCalendarDayCell.self)) { [weak self] (index, date, cell) in
        guard let self = self else { return }
        let isCurrentMonth = Calendar.current.isDate(date, equalTo: self.currentMonth, toGranularity: .month)
        let image = self.getImageForDate(date)
        cell.configure(with: date, isCurrentMonth: isCurrentMonth, hasEvent: false, image: image, today: self.today)
      }
      .disposed(by: disposeBag)
    
    monthChangedSubject
      .subscribe(with: self, onNext:  { owner, newDate in
        owner.updateMonth(newDate)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateDates() {
    let newDateForMonth = generateDatesForMonth(currentMonth)
    dateRelay.accept(newDateForMonth)
    collectionView.reloadData()
  }
  
  private func generateDatesForMonth(_ month: Date) -> [Date] {
    let calendar = Calendar.current
    
    guard let range = calendar.range(of: .day, in: .month, for: month),
          let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
      return []
    }
    
    let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
    let offsetDays = firstWeekday - calendar.firstWeekday
    
    let totalDays = range.count + offsetDays
    let numberOfWeeks = Int(ceil(Double(totalDays) / 7.0))
    
    return (0..<(numberOfWeeks * 7)).compactMap { day in
      calendar.date(byAdding: .day, value: day - offsetDays, to: firstDayOfMonth)
    }
  }
  
  public func updateMonth(_ newMonth: Date) {
    currentMonth = newMonth
    today = Calendar.current.startOfDay(for: Date())
    updateDates()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    collectionView.pin.all()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  private func getImageForDate(_ date: Date) -> UIImage? {
    return nil
  }
}

extension WalWalCalendarMonthView: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 42, height: 42)
  }
}
