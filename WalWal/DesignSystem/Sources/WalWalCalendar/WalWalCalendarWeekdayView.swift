//
//  WalWalCalendarWeekdayView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import Then

final public class WalWalCalendarWeekdayView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private var weekdayLabels = [UILabel]()
  
  // MARK: - Properties
  
  private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
  private let weekdayFont: UIFont
  private let normalTextColor: UIColor
  private let todayTextColor: UIColor
  
  // MARK: - Initializers
  
  public init(
    font: UIFont = .systemFont(ofSize: 14, weight: .semibold),
    normalColor: UIColor = .lightGray,
    todayColor: UIColor = .black
  ) {
    self.weekdayFont = font
    self.normalTextColor = normalColor
    self.todayTextColor = todayColor
    super.init(frame: .zero)
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  private func setLayout() {
    addSubview(containerView)
    
    let calendar = Calendar.current
    let today = calendar.component(.weekday, from: Date()) - 1
    
    for (index, weekday) in weekdays.enumerated() {
      let label = UILabel().then {
        $0.text = weekday
        $0.font = weekdayFont
        $0.textAlignment = .center
        $0.textColor = index == today ? todayTextColor : normalTextColor
      }
      weekdayLabels.append(label)
    }
    
    containerView.flex.direction(.row).justifyContent(.spaceAround).define { flex in
      for label in weekdayLabels {
        flex.addItem(label).grow(1)
      }
    }
  }
}
