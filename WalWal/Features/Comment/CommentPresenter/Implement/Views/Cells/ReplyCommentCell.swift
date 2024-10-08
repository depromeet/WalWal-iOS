//
//  ReplyCommentCell.swift
//  CommentPresenterImp
//
//  Created by 조용인 on 10/8/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit
import CommentDomain

import Then
import FlexLayout
import PinLayout

final class ReplyCommentCell: UITableViewCell, ReusableView {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias AssetColor = ResourceKitAsset.Colors
  
  // 컨테이너 뷰 추가
  private let rootContainerView = UIView()
  
  private let profileImageAndBodyContainer = UIView().then {
    $0.backgroundColor = .blue
  }
  private let bodyContainer = UIView().then {
    $0.backgroundColor = .red.withAlphaComponent(0.5)
  }
  private let nicknameAndTimeContainer = UIView().then {
    $0.backgroundColor = .green.withAlphaComponent(0.5)
  }
  
  private let profileImageContainer = UIView()
  private let nicknameContainer = UIView()
  private let timeLabelContainer = UIView()
  private let contentLabelContainer = UIView()
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = AssetColor.gray200.color // 이미지가 없을 때 보여줄 배경색
    $0.layer.cornerRadius = 17
    $0.clipsToBounds = true
  }
  
  private let nicknameLabel = CustomLabel(font: FontKR.M1).then {
    $0.textColor = AssetColor.gray600.color
  }
  
  private let timeLabel = CustomLabel(font: FontKR.B2).then {
    $0.textColor = AssetColor.gray600.color
  }
  
  private let contentLabel = CustomLabel(font: FontKR.B3).then {
    $0.textColor = AssetColor.black.color
    $0.numberOfLines = 2
    $0.lineBreakMode = .byTruncatingTail
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setAttribute()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainerView.pin
      .top(0)
      .left(44 + 15)
      .right(15)
      .bottom(0)
    rootContainerView.flex
      .layout(mode: .adjustHeight)
    
    rootContainerView.flex.markDirty()
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    // 셀의 적절한 크기를 계산하여 반환
    let targetWidth = size.width
    rootContainerView.pin.width(targetWidth) // rootContainerView의 너비를 설정
    rootContainerView.flex.layout(mode: .adjustHeight) // FlexLayout으로 레이아웃 조정
    let height = rootContainerView.frame.height
    return CGSize(width: targetWidth, height: height)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image = nil
    nicknameLabel.text = nil
    contentLabel.text = nil
    timeLabel.text = nil
  }
  
  private func setAttribute() {
    self.selectionStyle = .none
    contentView.backgroundColor = AssetColor.white.color
  }
  
  private func setLayout() {
    contentView.addSubview(rootContainerView)
    
    rootContainerView.flex
      .justifyContent(.spaceBetween)
      .define { flex in
        flex.addItem(profileImageAndBodyContainer)
        flex.addItem()
          .height(20)
      }
    
    profileImageAndBodyContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(profileImageView)
          .size(34)
        flex.addItem(bodyContainer)
          .marginLeft(8)
      }
    
    
    bodyContainer.flex
      .define { flex in
        flex.addItem(nicknameAndTimeContainer)
        flex.addItem(contentLabel)
          .marginTop(2)
          .grow(1)
      }
    
    nicknameAndTimeContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(nicknameLabel)
        flex.addItem(timeLabel)
          .marginLeft(4)
      }
  }
  
  // 댓글과 대댓글을 설정하는 메서드
  func configure(with comment: FlattenCommentModel) {
    nicknameLabel.text = comment.writerNickname
    contentLabel.text = comment.content
    
    if let timeText = timeAgo(from: comment.createdAt) {
      timeLabel.text = timeText
    } else {
      timeLabel.text = comment.createdAt
    }
    
    if let imageUrl = URL(string: comment.writerProfileImageURL) {
      profileImageView.kf.setImage(with: imageUrl)
    }
    
    layoutIfNeeded() // 레이아웃을 즉시 업데이트하여 셀의 크기를 동적으로 조정
  }
  
  private func timeAgo(from dateString: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    
    guard let date = formatter.date(from: dateString) else { return nil }
    
    let now = Date()
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
    
    if let day = components.day, day >= 1 {
      return "\(day)일 전"
    } else if let hour = components.hour, hour >= 1 {
      return "\(hour)시간 전"
    } else if let minute = components.minute, minute >= 1 {
      return "\(minute)분 전"
    } else {
      return "조금 전"
    }
  }
}
