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
import RxSwift
import RxCocoa

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
  private let writerNicknameContainer = UIView()
  private let timeLabelContainer = UIView()
  private let contentLabelContainer = UIView()
  private let replyButtonContainer = UIView()
  
  public var parentId: Int? = nil
  
  public var disposeBag = DisposeBag()
  public var parentIdGetted = BehaviorRelay<Int?>(value: nil)
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = AssetColor.gray200.color
    $0.layer.cornerRadius = 17
    $0.clipsToBounds = true
  }
  
  private let nicknameLabel = CustomLabel(font: FontKR.M1).then {
    $0.textColor = AssetColor.gray600.color
  }
  
  private let timeLabel = CustomLabel(font: FontKR.B2).then {
    $0.textColor = AssetColor.gray600.color
  }
  
  private let writerNicknameLabel = CustomLabel(font: FontKR.B2).then {
    $0.textColor = AssetColor.walwalOrange.color
  }
  
  private let contentLabel = CustomLabel(font: FontKR.B3, lineBreakMode: .byCharWrapping).then {
    $0.textColor = AssetColor.black.color
    $0.numberOfLines = 0
  }
  
  public let replyButton = CustomLabel(font: FontKR.M1).then {
    $0.textColor = AssetColor.gray500.color
    $0.text = "답글 달기"
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setAttribute()
    setLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func bind() {
    replyButton.rx.tapped
      .withUnretained(self)
      .map{ owner, _ in return owner.parentId }
      .bind(to: parentIdGetted)
      .disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainerView.pin
      .top(0)
      .left(15.adjustedWidth)
      .right(0)
      .bottom(0)
    rootContainerView.flex
      .layout(mode: .adjustHeight)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let targetWidth = size.width
    rootContainerView.pin.width(targetWidth)
    rootContainerView.flex.layout(mode: .adjustHeight)
    let height = rootContainerView.frame.height
    return CGSize(width: targetWidth, height: height)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image = nil
    nicknameLabel.text = nil
    contentLabel.text = nil
    timeLabel.text = nil
    replyButton.isHidden = false
    writerNicknameLabel.text = ""
    disposeBag = DisposeBag()
  }
  
  private func setAttribute() {
    self.selectionStyle = .none
    contentView.backgroundColor = AssetColor.white.color
    contentView.addSubview(rootContainerView)
  }
  
  private func setLayout() {
    
    rootContainerView.flex
      .justifyContent(.spaceBetween)
      .paddingVertical(10.adjustedHeight)
      .define { flex in
        flex.addItem(profileImageAndBodyContainer)
        flex.addItem(replyButtonContainer)
          .marginTop(8.adjustedHeight)
          .marginLeft(42.adjustedWidth)
      }
    
    replyButtonContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(replyButton)
        $0.addItem()
          .grow(1)
      }
    
    profileImageAndBodyContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(profileImageView)
          .width(34.adjustedWidth)
          .height(34.adjustedHeight)
        flex.addItem(bodyContainer)
          .marginLeft(8.adjustedWidth)
          .grow(1)
          .shrink(1)
        flex.addItem()
          .width(15.adjustedWidth)
      }
    
    bodyContainer.flex
      .define { flex in
        flex.addItem(nicknameAndTimeContainer)
        flex.addItem(contentLabel)
          .marginTop(2.adjustedHeight)
          .grow(1)
      }
    
    nicknameAndTimeContainer.flex
      .direction(.row)
      .define { flex in
        flex.addItem(nicknameLabel)
        flex.addItem(timeLabel)
          .marginLeft(4.adjustedWidth)
        flex.addItem(writerNicknameLabel)
          .marginLeft(8.adjustedWidth)
      }
  }
  
  func configure(
    with comment: FlattenCommentModel,
    writerNickname: String,
    writerId: Int?
  ) {
    nicknameLabel.text = comment.writerNickname
    contentLabel.text = comment.content
    parentId = comment.commentID
    writerNicknameLabel.text = writerNickname == comment.writerNickname ? "작성자" : ""
    
    if let timeText = timeAgo(from: comment.createdAt) {
      timeLabel.text = timeText
    } else {
      timeLabel.text = comment.createdAt
    }
    
    if let defaultImage =  DefaultProfile(rawValue: comment.writerProfileImageURL) {
      profileImageView.image = defaultImage.image
    } else if let imageUrl = URL(string: comment.writerProfileImageURL) {
      profileImageView.kf.setImage(with: imageUrl)
    } else {
      profileImageView.image = DefaultProfile.yellowDog.image
    }
    
    if writerId == nil {
      nicknameLabel.textColor = AssetColor.gray400.color
      timeLabel.textColor = AssetColor.gray400.color
    }
    
    contentLabel.flex.markDirty()
    nicknameLabel.flex.markDirty()
    timeLabel.flex.markDirty()
    
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
  
  public func configFocusing() {
    UIView.animate(withDuration: 0.3, animations: {
      self.contentView.backgroundColor = AssetColor.gray150.color
    }, completion: { _ in
      UIView.animate(withDuration: 0.8) {
        self.contentView.backgroundColor = AssetColor.white.color
      }
    })
  }
}
