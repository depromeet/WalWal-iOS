//
//  WalWalCalendarDayCell.swift
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

final class WalWalCalendarDayCell: UICollectionViewCell {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.layer.cornerRadius = Metrics.cornerRadius
    $0.clipsToBounds = true
  }
  
  private let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let dateLabel = CustomLabel(font: Fonts.KR.B1).then {
    $0.textAlignment = .center
    $0.font = Fonts.EN.Caption
  }
  
  private let flowerImageView = UIImageView().then {
    $0.image = ResourceKitAsset.Sample.calendarFlowerSample.image
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }
  
  private let dashBorderLayer = CAShapeLayer()
  
  // MARK: - Properties
  
  private var currentFlowerPosition: FlowerPosition?
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttributes()
    setLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    applyLayout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    resetCell()
  }
  
  // MARK: - Methods
  
  func configure(
    with date: Date,
    isCurrentMonth: Bool,
    image: UIImage?,
    today: Date,
    showFlower: Bool,
    index: Int
  ) {
    setDateLabel(for: date)
    setBackgroundImage(image, isCurrentMonth: isCurrentMonth, isToday: date == today)
    setColors(for: date, isCurrentMonth: isCurrentMonth, today: today)
    setDashBorder(for: date, today: today, isCurrentMonth: isCurrentMonth)
    setFlower(showFlower: showFlower, index: index, isCurrentMonth: isCurrentMonth)
    guardUserInteraction(isCurrentMonth: isCurrentMonth)
  }
  
  private func setAttributes() {
    clipsToBounds = false
    contentView.clipsToBounds = false
    flowerImageView.layer.zPosition = 1000
    
    dashBorderLayer.fillColor = nil
    dashBorderLayer.strokeColor = Colors.walwalOrange.color.cgColor
    dashBorderLayer.lineDashPattern = [2.7, 1]
    dashBorderLayer.lineWidth = 2
  }
  
  private func setLayouts() {
    contentView.addSubview(containerView)
    addSubview(flowerImageView)
    
    containerView
      .flex
      .define { flex in
        flex.addItem(backgroundImageView)
          .position(.absolute)
          .all(0)
        flex.addItem()
          .direction(.column)
          .grow(1)
          .define { flex in
            flex.addItem(dateLabel)
              .marginTop(4)
              .width(100%)
          }
      }
    
    containerView.layer.addSublayer(dashBorderLayer)
  }
  
  private func applyLayout() {
    containerView
      .pin
      .all()
    containerView
      .flex
      .layout()
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: backgroundImageView.bounds,
      cornerRadius: Metrics.cornerRadius
    ).cgPath
    backgroundImageView.layer.mask = maskLayer
    
    let path = UIBezierPath(
      roundedRect: containerView.bounds,
      cornerRadius: Metrics.cornerRadius
    )
    dashBorderLayer.path = path.cgPath
    dashBorderLayer.frame = containerView.bounds
    
    if let position = currentFlowerPosition {
      updateFlowerPosition(position)
    }
  }
  
  private func resetCell() {
    backgroundImageView.image = nil
    containerView.backgroundColor = .clear
    dateLabel.layer.shadowOpacity = 0
    flowerImageView.isHidden = true
    currentFlowerPosition = nil
  }
  
  private func setDateLabel(for date: Date) {
    let day = Calendar.current.component(.day, from: date)
    dateLabel.text = "\(day)"
  }
  
  private func setBackgroundImage(_ image: UIImage?, isCurrentMonth: Bool, isToday: Bool) {
    backgroundImageView.image = isCurrentMonth ? image : nil
    backgroundImageView.layer.opacity = isToday ? 1 : 0.7
    backgroundImageView.isHidden = image == nil
  }
  
  private func setColors(
    for date: Date,
    isCurrentMonth: Bool,
    today: Date
  ) {
    let colorSet = ColorSet.getColors(
      for: date,
      isCurrentMonth: isCurrentMonth,
      today: today
    )
    dateLabel.textColor = colorSet.textColor
    containerView.backgroundColor = colorSet.backgroundColor
  }
  
  private func setFlower(showFlower: Bool, index: Int, isCurrentMonth: Bool) {
    flowerImageView.isHidden = !showFlower || !isCurrentMonth
    if showFlower {
      currentFlowerPosition = FlowerPosition.getPosition(for: index)
      setNeedsLayout()
    } else {
      currentFlowerPosition = nil
    }
  }
  
  private func setDashBorder(for date: Date, today: Date, isCurrentMonth: Bool) {
    dashBorderLayer.isHidden = !Calendar.current.isDate(date, inSameDayAs: today) || !isCurrentMonth
  }
  
  private func updateFlowerPosition(_ position: FlowerPosition) {
    flowerImageView.frame = position.frame(in: bounds)
  }
  
  private func guardUserInteraction(isCurrentMonth: Bool) {
    isUserInteractionEnabled = isCurrentMonth
  }
}

// MARK: - WalWalCalendarDayCell Extension

extension WalWalCalendarDayCell {
  private enum Metrics {
    static let cornerRadius: CGFloat = 10
    static let dateFontSize: CGFloat = 14
    static let flowerSize: CGFloat = 30
  }
  
  private enum FlowerPosition {
    case topRight, topLeft, bottomRight
    
    static func getPosition(for index: Int) -> FlowerPosition {
      switch index {
      case 8: return .topLeft
      case 18: return .topRight
      case 30: return .bottomRight
      default: return .topRight
      }
    }
    
    func frame(in bounds: CGRect) -> CGRect {
      let size = Metrics.flowerSize
      switch self {
      case .topRight:
        return CGRect(x: bounds.maxX - size + 15, y: bounds.minY - 15, width: size, height: size)
      case .topLeft:
        return CGRect(x: bounds.minX - 11, y: bounds.minY - 15, width: size, height: size)
      case .bottomRight:
        return CGRect(x: bounds.maxX - size + 13, y: bounds.maxY - size + 15, width: size, height: size)
      }
    }
  }
  
  /// 컬러 확정 되면, hex로 정의해놓은 값 수정 예정
  private enum ColorSet {
    static func getColors(
      for date: Date,
      isCurrentMonth: Bool,
      today: Date
    ) -> (textColor: UIColor, backgroundColor: UIColor) {
      if date < today {
        return isCurrentMonth
        ? (Colors.white.color, Colors.gray800.color)
        : ((Colors.gray100.color), (Colors.gray100.color))
      } else if Calendar.current.isDate(date, inSameDayAs: today) {
        return isCurrentMonth
        ? (Colors.walwalOrange.color, Colors.walwalBeige.color)
        : ((Colors.gray100.color), (Colors.gray100.color))
      } else {
        return isCurrentMonth
        ? (Colors.black.color, UIColor(hex: 0xEFEFEF))
        : ((Colors.gray100.color), (Colors.gray100.color))
      }
    }
  }
}
