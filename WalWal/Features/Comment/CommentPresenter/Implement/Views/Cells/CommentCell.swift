//
//  CommentCell.swift
//  CommentPresenter
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit
import CommentDomain

import Then
import FlexLayout
import PinLayout

final class CommentCell: UITableViewCell, ReusableView {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias AssetColor = ResourceKitAsset.Colors
  
  // 컨테이너 뷰 추가
  private let rootContainerView = UIView()
  
  private let profileImageAndBodyContainer = UIView()
  
  private let bodyContainer = UIView()
  
  private let nicknameAndTimeContainer = UIView()
  
  private let profileImageContainer = UIView()
  private let nicknameContainer = UIView()
  private let timeLabelContainer = UIView()
  private let contentLabelContainer = UIView()
  private let replyButtonContainer = UIView()
  
  // 댓글과 대댓글을 구분하지 않고 모두 하나의 셀에서 처리
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
    $0.numberOfLines = 0
  }
  
  private let replyButton = CustomLabel(font: FontKR.M1).then {
    $0.textColor = AssetColor.gray500.color
    $0.text = "답글 달기"
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
      .all()
    rootContainerView.flex
      .layout(mode: .adjustHeight)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image = nil
    nicknameLabel.text = nil
    contentLabel.text = nil
    timeLabel.text = nil
    replyButton.isHidden = false // 기본적으로 답글 달기 버튼을 보이도록 설정
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
        flex.addItem(replyButtonContainer)
          .marginTop(8)
          .marginLeft(42)
      }
    
    profileImageAndBodyContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(profileImageContainer)
        flex.addItem(bodyContainer)
          .marginLeft(8)
      }
    
    bodyContainer.flex
      .define { flex in
        flex.addItem(nicknameAndTimeContainer)
        flex.addItem(contentLabelContainer)
          .marginTop(2)
      }
    
    nicknameAndTimeContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(nicknameContainer)
        flex.addItem(timeLabelContainer)
          .marginLeft(4)
      }
    
    profileImageContainer.flex
      .define { flex in
        flex.addItem(profileImageView)
          .size(34)
      }
    
    nicknameContainer.flex
      .define { flex in
        flex.addItem(nicknameLabel)
      }
    
    timeLabelContainer.flex
      .define { flex in
        flex.addItem(timeLabel)
      }
    
    contentLabelContainer.flex
      .define { flex in
        flex.addItem(contentLabel)
      }
    
    replyButtonContainer.flex
      .define { flex in
        flex.addItem(replyButton)
      }
    
  }
  
  // 댓글과 대댓글을 설정하는 메서드
  func configure(with comment: FlattenCommentModel) {
    nicknameLabel.text = comment.writerNickname
    contentLabel.text = comment.content
    
    if let timeText = timeAgo(from: comment.createdAt) { timeLabel.text = timeText }
    else { timeLabel.text = comment.createdAt }
    
    if let imageUrl = URL(string: comment.writerProfileImageURL) {
      profileImageView.kf.setImage(with: imageUrl)
    }
    
    // 대댓글에 대한 들여쓰기 (paddingLeft) 설정
    let isReply = comment.parentID != nil
    rootContainerView.flex.paddingLeft(isReply ? 40 : 0) // 대댓글인 경우 들여쓰기 적용
    
    // 대댓글이면 '답글 달기' 버튼을 숨김
    replyButton.isHidden = isReply
    
    layoutIfNeeded()
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
