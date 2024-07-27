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
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.layer.cornerRadius = Metrics.cornerRadius
    $0.clipsToBounds = true
  }
  
  private let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let dateLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: Metrics.dateFontSize, weight: .medium)
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
  
  func configure(with date: Date, isCurrentMonth: Bool, image: UIImage?, today: Date, showFlower: Bool, index: Int) {
    setDateLabel(for: date)
    setBackgroundImage(image)
    setColors(for: date, isCurrentMonth: isCurrentMonth, today: today)
    setFlower(showFlower: showFlower, index: index)
    setDashBorder(for: date, today: today)
  }
  
  private func setAttributes() {
    clipsToBounds = false
    contentView.clipsToBounds = false
    flowerImageView.layer.zPosition = 1000
    
    dashBorderLayer.fillColor = nil
    dashBorderLayer.strokeColor = ResourceKitAsset.Colors.walwalOrange.color.cgColor
    dashBorderLayer.lineDashPattern = [2.7, 1]
    dashBorderLayer.lineWidth = 2
  }
  
  private func setLayouts() {
    contentView.addSubview(containerView)
    addSubview(flowerImageView)
    
    containerView.flex.define { flex in
      flex.addItem(backgroundImageView).position(.absolute).all(0)
      flex.addItem().direction(.column).grow(1).define { flex in
        flex.addItem(dateLabel).marginTop(4).width(100%)
      }
    }
    
    containerView.layer.addSublayer(dashBorderLayer)
  }
  
  private func applyLayout() {
    containerView.pin.all()
    containerView.flex.layout()
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(roundedRect: backgroundImageView.bounds, cornerRadius: Metrics.cornerRadius).cgPath
    backgroundImageView.layer.mask = maskLayer
    
    let path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: Metrics.cornerRadius)
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
  
  private func setBackgroundImage(_ image: UIImage?) {
    backgroundImageView.image = image
    backgroundImageView.layer.opacity = image != nil ? 0.8 : 1
    backgroundImageView.isHidden = image == nil
  }
  
  private func setColors(for date: Date, isCurrentMonth: Bool, today: Date) {
    let colorSet = ColorSet.getColors(for: date, isCurrentMonth: isCurrentMonth, today: today)
    dateLabel.textColor = colorSet.textColor
    containerView.backgroundColor = colorSet.backgroundColor
  }
  
  private func setFlower(showFlower: Bool, index: Int) {
    flowerImageView.isHidden = !showFlower
    if showFlower {
      currentFlowerPosition = FlowerPosition.getPosition(for: index)
      setNeedsLayout()
    } else {
      currentFlowerPosition = nil
    }
  }
  
  private func setDashBorder(for date: Date, today: Date) {
    dashBorderLayer.isHidden = !Calendar.current.isDate(date, inSameDayAs: today)
  }
  
  private func updateFlowerPosition(_ position: FlowerPosition) {
    flowerImageView.frame = position.frame(in: bounds)
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
      case 2: return .topLeft
      case 12: return .topRight
      case 22: return .bottomRight
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
        ? (ResourceKitAsset.Colors.white.color, UIColor(hex: 0xCCCCCC))
        : (UIColor(hex: 0xCCCCCC), UIColor(hex: 0xA3A3A3))
      } else if Calendar.current.isDate(date, inSameDayAs: today) {
        return (ResourceKitAsset.Colors.walwalOrange.color, ResourceKitAsset.Colors.walwalBeige.color)
      } else {
        return isCurrentMonth
        ? (ResourceKitAsset.Colors.black.color, UIColor(hex: 0xEFEFEF))
        : (UIColor(hex: 0xCCCCCC), UIColor(hex: 0xF4F4F4))
      }
    }
  }
}
