//
//  WalWalCalendarWeekdayView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import Then

final class WalWalCalendarWeekdayView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private var weekdayLabels: [UILabel] = []
  
  // MARK: - Initializers
  
  init() {
    super.init(frame: .zero)
    setAttributes()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setAttributes() {
    let today = Calendar.current.component(.weekday, from: Date()) - 1
    
    weekdayLabels = Weekday.allCases.enumerated().map { index, weekday in
      UILabel().then {
        $0.text = weekday.shortName
        $0.font = ResourceKitFontFamily.KR.B1
        $0.textAlignment = .center
        $0.textColor = index == today ? Const.todayColor : Const.defaultColor
      }
    }
  }
  
  private func setupLayout() {
    addSubview(containerView)
    
    containerView
      .flex
      .direction(.row)
      .justifyContent(.spaceAround)
      .define { flex in
        weekdayLabels.forEach { label in
          flex.addItem(label)
            .grow(1)
        }
      }
  }
}

// MARK: - WalWalCalendarWeekdayView Extension

private extension WalWalCalendarWeekdayView {
  enum Const {
    static let todayColor = ResourceKitAsset.Colors.gray700.color
    static let defaultColor = ResourceKitAsset.Colors.gray500.color
  }
  
  enum Weekday: Int, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var shortName: String {
      switch self {
      case .sunday: return "일"
      case .monday: return "월"
      case .tuesday: return "화"
      case .wednesday: return "수"
      case .thursday: return "목"
      case .friday: return "금"
      case .saturday: return "토"
      }
    }
  }
}
