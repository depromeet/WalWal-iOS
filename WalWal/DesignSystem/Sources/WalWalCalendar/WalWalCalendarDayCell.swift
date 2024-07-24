//
//  WalWalCalendarDayCell.swift
//  DesignSystem
//
//  Created by 조용인 on 7/23/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FlexLayout
import PinLayout
import Then

public class WalWalCalendarDayCell: UICollectionViewCell {
  private let containerView = UIView()
  
  private let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let dateLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 14, weight: .medium)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(containerView)
    
    containerView.flex.define { flex in
      flex.addItem(backgroundImageView).position(.absolute).all(0)
      flex.addItem().direction(.column).grow(1).define { flex in
        flex.addItem(dateLabel).marginTop(4).width(100%)
      }
    }
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
    
    self.layer.cornerRadius = 10
    self.clipsToBounds = true
    backgroundImageView.layer.cornerRadius = 10
  }
  
  public func configure(with date: Date, isCurrentMonth: Bool, hasEvent: Bool, image: UIImage?, today: Date) {
    let day = Calendar.current.component(.day, from: date)
    dateLabel.text = "\(day)"
    
    if let image = image {
      /// 이미지가 있는 경우
      backgroundImageView.image = image
      backgroundImageView.isHidden = false
      containerView.backgroundColor = .clear
    } else {
      /// 이미지가 없는 경우
      backgroundImageView.image = nil
      backgroundImageView.isHidden = true
      
      if !isCurrentMonth {
        /// 현재 월에 해당하지 않는 날짜
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
      } else if date < today {
        /// 오늘 이전 날짜
        containerView.backgroundColor = .darkGray
      } else if Calendar.current.isDate(date, inSameDayAs: today) {
        /// 오늘
        containerView.backgroundColor = .orange.withAlphaComponent(0.3)
      } else {
        /// 오늘 이후 날짜
        containerView.backgroundColor = .lightGray
      }
    }
    
    /// 날짜 텍스트 색상 설정
    if date < today {
      dateLabel.textColor = .white
    } else if Calendar.current.isDate(date, inSameDayAs: today) {
      dateLabel.textColor = .orange
    } else {
      dateLabel.textColor = isCurrentMonth ? .black : .gray
    }
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    backgroundImageView.image = nil
    containerView.backgroundColor = .clear
    dateLabel.layer.shadowOpacity = 0
  }
}
