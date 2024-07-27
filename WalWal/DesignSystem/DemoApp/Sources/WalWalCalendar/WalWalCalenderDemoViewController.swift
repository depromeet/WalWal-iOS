//
//  WalWalCalenderDemoViewController.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
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

final class WalWalCalenderDemoViewController: UIViewController {
  
  // MARK: - UI
  
  private let rootView = UIView().then {
    $0.backgroundColor = UIColor(hex: 0xF7F8FA)
  }
  
  private let calendar: WalWalCalendar
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  /// WalWalCalenderDemoViewController를 초기화합니다.
  /// - Parameter walwalCalendarModels: 초기 캘린더 데이터 모델
  public init(walwalCalendarModels: [WalWalCalendarModel] = []) {
    self.calendar = WalWalCalendar()
    super.init(nibName: nil, bundle: nil)
    setupCalendarData(walwalCalendarModels)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayouts()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootView.pin.all(view.pin.safeArea)
    rootView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setLayouts() {
    view.addSubview(rootView)
    
    rootView.flex.define { flex in
      flex.addItem(calendar).grow(1)
    }
  }
  
  private func setupCalendarData(_ models: [WalWalCalendarModel]) {
#if DEBUG
    let sampleData = SampleDataGenerator.createRandomSampleCalendarModels()
    calendar.walwalCalendarModels.accept(sampleData)
#else
    calendar.walwalCalendarModels.accept(models)
#endif
  }
  
  private func bind() {
    calendar.selectedDayData
      .subscribe(with: self, onNext: { owner, data in
        owner.showAlert(with: data)
      })
      .disposed(by: disposeBag)
  }
  
  private func showAlert(with data: WalWalCalendarModel) {
    let alert = UIAlertController(
      title: "선택된 날짜: \(data.date)",
      message: "현재 선택된 이미지의 ID는: \"\(data.imageId)\"입니다",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "닫기", style: .default))
    present(alert, animated: true)
  }
}

// MARK: - Sample Data Generator

private enum SampleDataGenerator {
  static func createRandomSampleCalendarModels(count: Int = 50) -> [WalWalCalendarModel] {
    let sampleImageData = ResourceKitAsset.Sample.calendarCellSample.image.pngData() ?? Data()
    let calendar = Calendar.current
    let today = Date()
    let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: today)!
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let sampleModels = (1...count).map { _ -> WalWalCalendarModel in
      let randomDate = Date(timeIntervalSince1970: .random(in: oneYearAgo.timeIntervalSince1970...today.timeIntervalSince1970))
      let dateString = dateFormatter.string(from: randomDate)
      let id = "\(dateString)의 이미지 입니당 🐶"
      return WalWalCalendarModel(imageId: id, date: dateString, imageData: sampleImageData)
    }
    
    return sampleModels.sorted { $0.date < $1.date }
  }
}
