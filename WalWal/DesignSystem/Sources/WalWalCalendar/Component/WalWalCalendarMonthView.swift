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

final class WalWalCalendarMonthView: UIView {
  
  private typealias CellData = (date: Date, model: WalWalCalendarModel?)
  
  // MARK: - UI
  
  private let collectionView: UICollectionView
  
  // MARK: - Properties
  
  private var currentMonth: Date
  
  private var today: Date
  
  private let dateRelay = BehaviorRelay<[Date]>(value: [])
  
  private let cellDataRelay: BehaviorRelay<[WalWalCalendarModel]>
  
  fileprivate let cellTappedRelay = PublishRelay<WalWalCalendarModel?>()
  
  private let disposeBag = DisposeBag()
  
  let monthChangedSubject = PublishSubject<Date>()
  
  // MARK: - Initializers
  
  init(
    initialDate: Date = Date(),
    cellDatas: [WalWalCalendarModel]
  ) {
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout())
    self.currentMonth = initialDate
    self.today = Calendar.current.startOfDay(for: Date())
    self.cellDataRelay = BehaviorRelay(value: cellDatas)
    super.init(frame: .zero)
    setLayouts()
    bind()
    updateDates()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.pin.all()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    addSubview(collectionView)
    collectionView.register(
      WalWalCalendarDayCell.self,
      forCellWithReuseIdentifier: Const.cellIdentifier
    )
    collectionView.backgroundColor = UIColor(hex: 0xF7F8FA)
  }
  
  private func bind() {
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(dateRelay, cellDataRelay)
      .map(createDateCellDataPairs)
      .bind(to: collectionView.rx.items(
        cellIdentifier: Const.cellIdentifier,
        cellType: WalWalCalendarDayCell.self
      )) { [weak self] (index, data, cell) in
        self?.configureCell(cell, with: data, at: index)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .withLatestFrom(
        Observable.combineLatest(dateRelay, cellDataRelay)
      ) { [weak self] indexPath, data in
        self?.getCellDataForIndexPath(indexPath, dates: data.0, cellDatas: data.1)
      }
      .bind(to: cellTappedRelay)
      .disposed(by: disposeBag)
    
    monthChangedSubject
      .subscribe(with: self, onNext: { owner, month in
        owner.updateMonth(month)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Methods
  func updateMonth(_ newMonth: Date) {
    currentMonth = newMonth
    today = Calendar.current.startOfDay(for: Date())
    updateDates()
  }
  
  func updateCellDatas(_ newCellDatas: [WalWalCalendarModel]) {
    cellDataRelay.accept(newCellDatas)
  }
  
  // MARK: - Methods
  private func configureCell(
    _ cell: WalWalCalendarDayCell,
    with data: CellData,
    at index: Int
  ) {
    let isCurrentMonth = Calendar.current.isDate(
      data.date,
      equalTo: currentMonth,
      toGranularity: .month
    )
    let image = data.model.flatMap { UIImage(data: $0.imageData) }
    let showFlower = (index + 1) % 10 == 3 && index <= 23
    cell.configure(
      with: data.date,
      isCurrentMonth: isCurrentMonth,
      image: image,
      today: today,
      showFlower: showFlower, 
      index: index
    )
  }
  
  private func getCellDataForIndexPath(
    _ indexPath: IndexPath, dates: [Date],
    cellDatas: [WalWalCalendarModel]
  ) -> WalWalCalendarModel? {
    guard indexPath.item < dates.count else { return nil }
    let date = dates[indexPath.item]
    return cellDatas.first { $0.date == date.toString() }
  }
  
  private func createDateCellDataPairs(
    dates: [Date],
    cellDatas: [WalWalCalendarModel]
  ) -> [CellData] {
    let cellDataDict = Dictionary(grouping: cellDatas, by: { $0.date })
    return dates.map { date in
      (date, cellDataDict[date.toString()]?.first)
    }
  }
  
  private func updateDates() {
    dateRelay.accept(generateDatesForMonth(currentMonth))
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
  
  private static func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = Const.interitemSpacing
    layout.minimumLineSpacing = Const.lineSpacing
    layout.sectionInset = UIEdgeInsets(top: Const.sectionTopInset, left: 0, bottom: 0, right: 0)
    return layout
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WalWalCalendarMonthView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return Const.cellSize
  }
}

// MARK: - Extensions WalWalCalendarMonthView

private extension WalWalCalendarMonthView {
  enum Const {
    static let cellIdentifier = "DayCell"
    static let interitemSpacing: CGFloat = 6
    static let lineSpacing: CGFloat = 24
    static let sectionTopInset: CGFloat = 18
    static let cellSize = CGSize(width: 42, height: 42)
  }
}

// MARK: - Date Extension

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalCalendarMonthView {
  var selectedCell: ControlEvent<WalWalCalendarModel?> {
    ControlEvent(events: base.cellTappedRelay.asObservable())
  }
}
